import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FoodAnalyzerPage extends StatefulWidget {
  @override
  FoodAnalyzerPageState createState() => FoodAnalyzerPageState();
}

class FoodAnalyzerPageState extends State<FoodAnalyzerPage> {
  Uint8List? _imageBytes;
  String? _analysisResult;
  bool _isLoading = false;
  String _selectedRecipeType = 'Any';

  final List<String> _recipeTypes = [
    'Any',
    'Dessert',
    'Main Dish',
    'Soup',
    'Salad',
    'Snack',
    'Beverage',
    'Other'
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _analysisResult = null;
      });
      await _analyzeImageWithGemini(bytes);
    }
  }

  Future<void> _analyzeImageWithGemini(Uint8List imageBytes) async {
    setState(() => _isLoading = true);
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final base64Image = base64Encode(imageBytes);

    final prompt = '''
This is a photo of a plant. Identify whether it is edible or not.

Respond in the following format:

Edibility: Indicate if it is edible or not and explain.

Safety Disclaimer: Add any important cautionary advice for handling or consuming the plant.

Recipe: Provide a simple "${_selectedRecipeType == 'Any' ? 'suitable' : _selectedRecipeType.toLowerCase()}" recipe using this plant if it's edible.

If not edible, omit the Recipe section and add a warning instead.
''';

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey');

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
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
      setState(() => _analysisResult =
          "Failed to analyze image. Please try again. [${response.statusCode}] ${response.body}");
    }

    setState(() => _isLoading = false);
  }

  Map<String, String> _parseSections(String text) {
    final lines = text.split('\n');
    final Map<String, String> sections = {};
    String? currentSection;

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      if (line.contains(':')) {
        final parts = line.split(':');
        currentSection = parts.first.trim();
        sections[currentSection] = parts.sublist(1).join(':').trim();
      } else if (currentSection != null) {
        sections[currentSection] =
            '${sections[currentSection]}\n${line.trim()}';
      }
    }

    return sections;
  }

  List<Widget> _buildStyledSections(Map<String, String> sections) {
    return sections.entries.map((entry) {
      IconData icon;
      Color color;

      switch (entry.key.toLowerCase()) {
        case 'edibility':
          icon = Icons.spa;
          color = Colors.green.shade100;
          break;
        case 'safety disclaimer':
          icon = Icons.warning_amber_rounded;
          color = Colors.yellow.shade100;
          break;
        case 'recipe':
          icon = Icons.restaurant_menu;
          color = Colors.orange.shade100;
          break;
        default:
          icon = Icons.info_outline;
          color = Colors.grey.shade200;
      }

      return Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: Colors.deepPurple),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.value,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edibility & Recipe Checker"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Recipe Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: _selectedRecipeType,
              items: _recipeTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedRecipeType = value ?? 'Any');
              },
            ),
            const SizedBox(height: 24),

            // Upload container UI
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.05),
                  border: Border.all(color: Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.upload_file, color: Colors.deepPurpleAccent),
                    SizedBox(width: 12),
                    Text("Tap to upload a plant photo",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Image preview with loading
            if (_imageBytes != null)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(_imageBytes!, height: 180),
                  ),
                  const SizedBox(height: 10),
                  if (_isLoading)
                    const LinearProgressIndicator(minHeight: 6),
                ],
              ),

            const SizedBox(height: 20),

            // AI styled response
            if (_analysisResult != null)
              Expanded(
                child: ListView(
                  children:
                      _buildStyledSections(_parseSections(_analysisResult!)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
