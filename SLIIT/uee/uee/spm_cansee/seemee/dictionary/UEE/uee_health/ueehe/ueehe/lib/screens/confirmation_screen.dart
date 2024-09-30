import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
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

    // Define the Tween for scaling the navigation arrow and circles
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Send email when landing on this screen
    sendEmail();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller when done
    super.dispose();
  }

  Future<void> sendEmail() async {
    final smtpServer = gmail(
        'your_email@gmail.com', 'your_password'); // Use your Gmail credentials

    // Create the email message
    final message = Message()
      ..from = Address('rawart.media@gmail.com', 'MedCare App')
      ..recipients.add('rawart.media@gmail.com') // Recipient email
      ..subject = 'SOS Confirmation - User Location ${DateTime.now()}'
      ..text = 'The user is at the following location:\n\n'
          'Location: ${widget.location}\n'
          'Latitude: ${widget.latitude}\n'
          'Longitude: ${widget.longitude}\n\n'
          'Support is on the way!';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent. \n$e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
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
                  Color.fromARGB(255, 255, 71, 71)
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
                        animation: _controller,
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
                        animation: _controller,
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
                        animation: _controller,
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
                          HapticFeedback.heavyImpact();
                          // make short vibration

                          HapticFeedback.vibrate();
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
