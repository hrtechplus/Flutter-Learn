import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final String location;
  final double latitude;
  final double longitude;

  const ConfirmationScreen({
    super.key,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top App Bar section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu,
                            size: 28, color: Colors.black54),
                        onPressed: () {},
                      ),
                      const Text(
                        "Hello, Hasindu",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Support message
                const Center(
                  child: Text(
                    "Support is On the Way!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Navigation Arrow inside a circle
                Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.redAccent,
                        width: 8,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.navigation, // Navigation arrow icon
                        size: 80,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Bottom section with microphone and message
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Don't panic! We have acknowledged them, your support is on the way.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Return to the previous screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
