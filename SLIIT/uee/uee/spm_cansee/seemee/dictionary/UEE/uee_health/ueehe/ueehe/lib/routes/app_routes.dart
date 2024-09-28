import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/essential_info_form_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/confirmation_screen.dart';
import '../screens/countdown_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/sos_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => SplashScreen(), // Splash screen is the initial route
      '/welcome': (context) =>
          WelcomeScreen(), // Welcome screen for first-time users
      '/essentialForm': (context) =>
          EssentialInfoFormScreen(), // Form for collecting user info
      '/home': (context) => HomeScreen(), // Main SOS screen
      '/chat': (context) => ChatScreen(), // Existing chat screen
      '/confirmation': (context) => ConfirmationScreen(
          location: '',
          latitude: 0.0,
          longitude: 0.0), // Existing confirmation screen
      '/countdown': (context) => CountdownScreen(
          location: '', latitude: 0.0, longitude: 0.0), // Countdown screen
      '/history': (context) => HistoryScreen(), // History screen
      '/profile': (context) => ProfileScreen(), // Profile screen
      '/sos': (context) => SosScreen(), // SOS screen
    };
  }
}
