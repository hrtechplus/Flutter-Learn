import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Skip Button in the top-right corner
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: () {
                    // Navigate to SOS screen directly
                    Navigator.pushReplacementNamed(context, '/sos');
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.redAccent),
                  label: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const Spacer(), // To push logo and text towards the center

              // App Logo
              Image.asset(
                'assets/images/uee_logo.png', // Your logo path
                height: 180, // Adjust the height based on your preference
              ),
              SizedBox(height: 40), // Spacing between logo and app name

              // App Name
              const Text(
                "MedCare",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // Tagline
              const SizedBox(height: 10),
              const Text(
                "Your trusted partner in emergency,\nproviding immediate support.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const Spacer(), // Spacer to push button to the bottom

              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to profile setup screen
                  Navigator.pushReplacementNamed(context, '/profileSetup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded button corners
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                  height: 10), // Spacing between button and sign-in text

              // Existing User? Sign in
              GestureDetector(
                onTap: () {
                  // Add your sign-in functionality here
                },
                child: const Text(
                  "Existing User?",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 40), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
