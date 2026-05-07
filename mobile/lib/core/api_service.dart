import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.1.8:8000'; // Your local IP

  Future<Map<String, dynamic>> processOMR(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/process-omr'));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to process OMR: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
