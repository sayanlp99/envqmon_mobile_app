import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:envqmon/app.dart';
import 'package:envqmon/firebase_options.dart';

// Handle background messages for FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permissions and handle messages
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Get and print FCM token for testing
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Optional: Add in-app notification display if needed
  });

  // Handle app opened from notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Add navigation logic here if needed
  });

  runApp(const EnvQMonApp());
}