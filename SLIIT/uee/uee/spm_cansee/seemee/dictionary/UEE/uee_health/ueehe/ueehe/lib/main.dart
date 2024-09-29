import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedCare App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: AppRoutes.splash, // Start with SplashScreen
      onGenerateRoute: AppRoutes.generateRoute, // Use the route generator
    );
  }
}
