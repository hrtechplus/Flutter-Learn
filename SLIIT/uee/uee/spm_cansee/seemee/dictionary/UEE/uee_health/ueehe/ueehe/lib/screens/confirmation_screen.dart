import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

class ConfirmationScreen extends StatefulWidget {
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
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for the pulsing effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration for one pulse
    )..repeat(
        reverse: true); // Repeat the animation in reverse for a pulsing effect

    // Initialize the Tween animation after the controller
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Call the method to initialize and send SMS
  }

  // Function to send SMS using background_sms package
  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 122, 122),
                  Color.fromARGB(255, 255, 71, 71),
                ], // Light to darker red
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
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
                    "Support is On the Way!!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Animated Navigation Arrow inside a ripple effect
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ripple Circle 1
                      AnimatedBuilder(
                        animation:
                            _animation, // Use the properly initialized _animation
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Ripple Circle 2
                      AnimatedBuilder(
                        animation:
                            _animation, // Same animation used for all circles
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value * 0.85,
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Ripple Circle 3
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value * 0.7,
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Navigation Arrow Icon (Center)
                      const Icon(
                        Icons.navigation, // Navigation arrow icon
                        size: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Bottom section with microphone and message
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
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
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
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
                          // make long vibration
                          // HapticFeedback.heavyImpact();
                          // // make short vibration
                          // HapticFeedback.vibrate();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 64),
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
