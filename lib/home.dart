

import 'package:flutter/material.dart';
import 'foodanalyzer.dart';
import 'account.dart';

void main() {
  runApp(GTApp());
}

class GTApp extends StatelessWidget {
  const GTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantSnap',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(primary: Colors.green.shade700),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(), 
    Placeholder(), 
    AccountPage(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
                'assets/logo.png',
                height: 28,
                width: 28,
                fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Text('PlantSnap AI'),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search))
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Scans'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodAnalyzerPage())),
              backgroundColor: Colors.green,
              child: Icon(Icons.camera_alt),
            )
          : null,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _FeatureButton(icon: Icons.camera_alt, label: 'Scan Plant', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodAnalyzerPage()))),
              _FeatureButton(icon: Icons.list_alt, label: 'Scan History', onTap: () {}),
              _FeatureButton(icon: Icons.receipt_long, label: 'Recipes', onTap: () {}),
              _FeatureButton(icon: Icons.menu_book, label: 'Guides', onTap: () {}),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Scans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, size: 16)
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                _RecentScanTile(title: 'Wild Mushroom', date: '2025/04/07 13:20'),
                _RecentScanTile(title: 'Mint Leaf', date: '2025/04/06 15:42'),
                _RecentScanTile(title: 'Unknown Plant', date: '2025/04/05 10:30'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FeatureButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(icon, color: Colors.green[700]),
            radius: 26,
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _RecentScanTile extends StatelessWidget {
  final String title;
  final String date;

  const _RecentScanTile({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(Icons.image, size: 40, color: Colors.green[700]),
        title: Text(title),
        subtitle: Text(date),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
