import 'package:flutter/material.dart';
import 'FoodAnalyzer.dart';


void main() {
  runApp(GTApp());
}

class GTApp extends StatelessWidget {
  const GTApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste Reduction and Recycling',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Reduction & Recycling'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Introduction
            Text(
              'Welcome to Waste Reduction & Recycling Guidance!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This app helps you identify waste items and provides tips on how to recycle, compost, or dispose of them properly.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),

            // Buttons for Key Features
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodAnalyzerPage()),
                );
              },
              child: Text('Identify Waste Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecyclingTipsPage()),
                );
              },
              child: Text('Get Recycling Tips'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RecyclingTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycling Tips'),
      ),
      body: Center(
        child: Text(
          'Here are some general recycling tips:\n- Plastic bottles go in the recycling bin.\n- Food scraps can be composted.\n- Paper items should be placed in the recycling bin.\n\nThese are just examples, and you can add more tips based on the waste items!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
