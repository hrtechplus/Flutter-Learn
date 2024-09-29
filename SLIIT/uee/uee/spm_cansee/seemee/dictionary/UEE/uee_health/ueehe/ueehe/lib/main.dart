import 'package:flutter/material.dart';
import 'package:ueehe/screens/essential_info_form_screen.dart';
import 'package:ueehe/screens/sos_screen.dart';
import 'package:ueehe/screens/splash_screen.dart';
import 'package:ueehe/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/essentialForm': (context) => EssentialInfoFormScreen(),
        '/sos': (context) => SosScreen(),
      },
    );
  }
}
