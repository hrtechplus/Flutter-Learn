import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/main_app_screen.dart'; // New main screen with bottom navigation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SOS App',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/', // Start with the Splash Screen
      routes: AppRoutes.getRoutes(), // Load routes from app_routes.dart
    );
  }
}
