import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError('Unsupported platform.');
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: dotenv.env['API_KEY_WEB']!,
        appId: '1:542835994680:web:a707c817e08b7354ba36cd',
        messagingSenderId: '542835994680',
        projectId: 'greentransport-kwy',
        authDomain: 'greentransport-kwy.firebaseapp.com',
        storageBucket: 'greentransport-kwy.firebasestorage.app',
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: dotenv.env['API_KEY_ANDROID']!,
        appId: '1:542835994680:android:aa93b7c3b77c41a7ba36cd',
        messagingSenderId: '542835994680',
        projectId: 'greentransport-kwy',
        storageBucket: 'greentransport-kwy.firebasestorage.app',
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: dotenv.env['API_KEY_IOS']!,
        appId: '1:542835994680:ios:a3e1d3879fc2cbdeba36cd',
        messagingSenderId: '542835994680',
        projectId: 'greentransport-kwy',
        storageBucket: 'greentransport-kwy.firebasestorage.app',
        iosBundleId: 'com.example.flutterApplication1',
      );

  static FirebaseOptions get macos => FirebaseOptions(
        apiKey: dotenv.env['API_KEY_MACOS']!,
        appId: '1:542835994680:android:aa93b7c3b77c41a7ba36cd',
        messagingSenderId: '542835994680',
        projectId: 'greentransport-kwy',
        storageBucket: 'greentransport-kwy.firebasestorage.app',
      );

  static FirebaseOptions get windows => FirebaseOptions(
        apiKey: dotenv.env['API_KEY_WINDOWS']!,
        appId: '1:542835994680:web:7d37cc15f06cee29ba36cd',
        messagingSenderId: '542835994680',
        projectId: 'greentransport-kwy',
        authDomain: 'greentransport-kwy.firebaseapp.com',
        storageBucket: 'greentransport-kwy.firebasestorage.app',
      );
}
