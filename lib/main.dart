
import 'package:flutter/material.dart';
import 'login.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "assets/.env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GTApp());
}



class GTApp extends StatelessWidget {
  const GTApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
      ),
    ),
    home: LoginScreen(),
  );
}
}