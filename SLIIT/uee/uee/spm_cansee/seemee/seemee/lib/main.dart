import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'user_form_screen.dart'; // Import the UserFormScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase Initialization
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      home: UserFormScreen(),
    );
  }
}
