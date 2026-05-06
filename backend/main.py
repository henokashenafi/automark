import os
import base64
import json
import cv2
import numpy as np
import google.generativeai as genai
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="AutoMark AI - Precision Left-Side Scanner")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
model = genai.GenerativeModel('models/gemini-flash-latest')

def remove_red_ink(img_bgr):
    hsv = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2HSV)
    lower_red1, upper_red1 = np.array([0, 50, 50]), np.array([10, 255, 255])
    lower_red2, upper_red2 = np.array([160, 50, 50]), np.array([180, 255, 255])
    mask = cv2.bitwise_or(cv2.inRange(hsv, lower_red1, upper_red1), cv2.inRange(hsv, lower_red2, upper_red2))
    result = img_bgr.copy()
    result[mask > 0] = [255, 255, 255]
    return result

def call_gemini(image_bgr, prompt):
    _, buffer = cv2.imencode('.jpg', image_bgr, [int(cv2.IMWRITE_JPEG_QUALITY), 95])
    response = model.generate_content([prompt, {'mime_type': 'image/jpeg', 'data': buffer.tobytes()}])
    text = response.text.strip()
    if "```json" in text: text = text.split("```json")[1].split("```")[0].strip()
    elif "```" in text: text = text.split("```")[1].split("```")[0].strip()
    return json.loads(text)

@app.post("/process-omr")
async def process_omr(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        img = remove_red_ink(img)
        h, w = img.shape[:2]

        # 1. HEADER (Top 35%)
        header = img[0:int(h*0.35), 0:w]
        identity = call_gemini(header, 'Return JSON: {"student_id": "string", "student_name": "string"}')

        # 2. TARGET LEFT SIDE ONLY (Questions 1-60 are in the left half of the sheet)
        left_half = img[int(h*0.35):h, 0:int(w*0.5)]
        lh, lw = left_half.shape[:2]

        # Split the left half into 3 vertical columns
        c1 = left_half[:, 0:int(lw*0.33)]
        c2 = left_half[:, int(lw*0.33):int(lw*0.66)]
        c3 = left_half[:, int(lw*0.66):lw]

        ans1 = call_gemini(c1, 'Extract Q1-20. Return JSON: {"answers": {"1": "A", "2": "B"...}}')
        ans2 = call_gemini(c2, 'Extract Q21-40. Return JSON: {"answers": {"21": "A", "22": "B"...}}')
        ans3 = call_gemini(c3, 'Extract Q41-60. Return JSON: {"answers": {"41": "A", "42": "B"...}}')

        return {
            "student_id": identity.get("student_id"),
            "student_name": identity.get("student_name"),
            "answers": {**ans1.get("answers", {}), **ans2.get("answers", {}), **ans3.get("answers", {})}
        }
    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
