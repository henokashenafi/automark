import React, { useState, useRef } from 'react';
import axios from 'axios';
import { motion, AnimatePresence } from 'framer-motion';
import { Upload, FileText, CheckCircle, User, Fingerprint, Loader2, RefreshCw } from 'lucide-react';
import './index.css';

interface OMRResult {
  student_id: string;
  student_name: string;
  answers: Record<string, string>;
}

function App() {
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<OMRResult | null>(null);
  const [error, setError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0];
    if (selectedFile) {
      setFile(selectedFile);
      setPreview(URL.createObjectURL(selectedFile));
      setResult(null);
      setError(null);
    }
  };

  const processImage = async () => {
    if (!file) return;

    setLoading(true);
    setError(null);
    const formData = new FormData();
    formData.append('file', file);

    try {
      const response = await axios.post('http://localhost:8000/process-omr', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      setResult(response.data);
    } catch (err) {
      console.error(err);
      setError('Failed to process image. Please ensure the backend is running and the API key is valid.');
    } finally {
      setLoading(false);
    }
  };

  const reset = () => {
    setFile(null);
    setPreview(null);
    setResult(null);
    setError(null);
  };

  return (
    <div className="app-wrapper">
      <div className="bg-mesh"></div>
      
      <div className="container">
        <header>
          <div className="logo-section">
            <span className="logo">AUTOMARK AI</span>
            <p style={{ color: 'var(--text-muted)', fontSize: '0.9rem' }}>Powered by Groq Llama 3.2 Vision</p>
          </div>
          <div className="status-badge status-online">Groq API Online</div>
        </header>

        <main>
          <AnimatePresence mode="wait">
            {!result ? (
              <motion.div 
                key="upload-section"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -20 }}
                className="glass-card"
              >
                {!preview ? (
                  <div 
                    className="upload-zone"
                    onClick={() => fileInputRef.current?.click()}
                  >
                    <Upload size={48} color="#8b5cf6" style={{ marginBottom: '1rem' }} />
                    <h2>Drop your OMR sheet here</h2>
                    <p style={{ color: 'var(--text-muted)', marginTop: '0.5rem' }}>PNG, JPG or JPEG (Max 10MB)</p>
                    <input 
                      type="file" 
                      hidden 
                      ref={fileInputRef} 
                      onChange={handleFileChange} 
                      accept="image/*"
                    />
                  </div>
                ) : (
                  <div className="preview-container">
                    <img 
                      src={preview} 
                      alt="Preview" 
                      style={{ width: '100%', maxHeight: '400px', objectFit: 'contain', borderRadius: '12px', marginBottom: '1.5rem', border: '1px solid var(--glass-border)' }} 
                    />
                    <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center' }}>
                      <button className="btn-primary" onClick={processImage} disabled={loading}>
                        {loading ? <Loader2 className="animate-spin" /> : 'Start AI Analysis'}
                      </button>
                      <button 
                        className="btn-primary" 
                        style={{ background: 'transparent', border: '1px solid var(--glass-border)' }}
                        onClick={reset}
                        disabled={loading}
                      >
                        Change Image
                      </button>
                    </div>
                  </div>
                )}
                
                {error && (
                  <p style={{ color: '#ef4444', textAlign: 'center', marginTop: '1rem' }}>{error}</p>
                )}
              </motion.div>
            ) : (
              <motion.div 
                key="result-section"
                initial={{ opacity: 0, scale: 0.95 }}
                animate={{ opacity: 1, scale: 1 }}
                className="results-container"
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
                  <h2 style={{ fontSize: '2rem' }}>Analysis Results</h2>
                  <button className="btn-primary" onClick={reset}>
                    <RefreshCw size={18} style={{ marginRight: '8px' }} /> New Sheet
                  </button>
                </div>

                <div className="results-grid">
                  <div className="glass-card identity-card">
                    <h3 style={{ marginBottom: '1.5rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                      <User size={20} color="#8b5cf6" /> Student Info
                    </h3>
                    
                    <div style={{ marginBottom: '1.5rem' }}>
                      <label style={{ color: 'var(--text-muted)', fontSize: '0.8rem' }}>NAME</label>
                      <p style={{ fontSize: '1.2rem', fontWeight: 600 }}>{result.student_name || 'Not Detected'}</p>
                    </div>

                    <div>
                      <label style={{ color: 'var(--text-muted)', fontSize: '0.8rem' }}>STUDENT ID</label>
                      <p style={{ fontSize: '1.2rem', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                        <Fingerprint size={18} /> {result.student_id || 'Not Detected'}
                      </p>
                    </div>
                  </div>

                  <div className="glass-card">
                    <h3 style={{ marginBottom: '1.5rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                      <CheckCircle size={20} color="#8b5cf6" /> Answer Grid
                    </h3>
                    <div className="answer-list">
                      {Object.entries(result.answers).map(([num, letter]) => (
                        <motion.div 
                          initial={{ opacity: 0, y: 10 }}
                          animate={{ opacity: 1, y: 0 }}
                          transition={{ delay: parseInt(num) * 0.02 }}
                          key={num} 
                          className="answer-item"
                        >
                          <span className="answer-number">Q{num}</span>
                          <span className="answer-letter">{letter || '-'}</span>
                        </motion.div>
                      ))}
                    </div>
                  </div>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </main>
      </div>
    </div>
  );
}

export default App;
