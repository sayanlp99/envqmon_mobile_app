import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:envqmon/app.dart';
import 'package:envqmon/firebase_options.dart';
import 'package:envqmon/core/services/network_test_service.dart';

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

  // Run network connectivity tests
  await NetworkTestService.runConnectivityTests();

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

// Helper function to register FCM token when app starts
Future<void> _registerFcmTokenOnAppStart() async {
  // This will be called after the app is built and providers are available
  // We'll handle this in the splash screen or dashboard
}