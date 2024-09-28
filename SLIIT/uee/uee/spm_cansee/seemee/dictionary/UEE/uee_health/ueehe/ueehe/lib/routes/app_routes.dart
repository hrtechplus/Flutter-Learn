import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/essential_info_form_screen.dart';
import '../screens/main_app_screen.dart'; // New main screen with bottom navigation

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => SplashScreen(), // Splash screen as the entry point
      '/welcome': (context) =>
          WelcomeScreen(), // Welcome screen for first-time users
      '/essentialForm': (context) =>
          EssentialInfoFormScreen(), // Form for collecting user info
      '/sos': (context) =>
          MainAppScreen(), // Main screen with bottom navigation bar
    };
  }
}
