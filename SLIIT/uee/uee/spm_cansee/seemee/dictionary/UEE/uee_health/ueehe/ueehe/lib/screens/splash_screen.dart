import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Show splash screen for 3 seconds before checking user info
    Timer(const Duration(seconds: 3), () {
      _checkUserInfo(context);
    });

    return Scaffold(
      body: Center(
        child: Text(
          "Welcome to SOS App",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Check if user info is stored in SharedPreferences
  Future<void> _checkUserInfo(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('fullName')) {
      // Navigate to home screen if info exists
      Navigator.pushReplacementNamed(context, '/sos');
    } else {
      // Navigate to welcome screen if no user info is found
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }
}
