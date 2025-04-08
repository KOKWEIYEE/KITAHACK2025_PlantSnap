import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class FoodAnalyzerPage extends StatefulWidget {
  
  @override
  FoodAnalyzerPageState createState() => FoodAnalyzerPageState();
}

class FoodAnalyzerPageState extends State<FoodAnalyzerPage> {
  File? _image;
  String? _analysisResult;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _analysisResult = null;
      });
      await _analyzeImageWithGemini(_image!);
    }
  }

  Future<void> _analyzeImageWithGemini(File image) async {
    setState(() => _isLoading = true);

    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=YOUR_API_KEY');

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": "Identify this meal and give nutrition facts, health tips, and eco-friendly suggestions."},
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Image,
              }
            }
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final text = decoded['candidates'][0]['content']['parts'][0]['text'];
      setState(() => _analysisResult = text);
    } else {
      setState(() => _analysisResult = "Failed to analyze image. Please try again.");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Food Nutrition Analyzer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Upload Meal Photo"),
            ),
            SizedBox(height: 20),
            if (_image != null)
              Image.file(_image!, height: 200),
            SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
            if (_analysisResult != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_analysisResult ?? '', style: TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

