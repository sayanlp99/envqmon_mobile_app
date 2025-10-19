import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:envqmon/app.dart';
import 'package:envqmon/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const EnvQMonApp());
}
