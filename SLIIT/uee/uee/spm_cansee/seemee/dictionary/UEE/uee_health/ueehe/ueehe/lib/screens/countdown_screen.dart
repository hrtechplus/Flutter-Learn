import 'package:flutter/material.dart';
import 'dart:async';
import 'confirmation_screen.dart';

class CountdownScreen extends StatefulWidget {
  final String location;
  final double latitude;
  final double longitude;

  const CountdownScreen({
    super.key,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _counter = 3; // Countdown starts at 3 seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0 && mounted) {
        setState(() {
          _counter--;
        });
      } else {
        timer.cancel();
        _onCountdownFinished(); // Call navigation method when the countdown finishes
      }
    });
  }

  void _onCountdownFinished() {
    // Ensure navigation to ConfirmationScreen with the necessary arguments
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          location: widget.location,
          latitude: widget.latitude,
          longitude: widget.longitude,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.menu, size: 28, color: Colors.black54),
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
            const Spacer(),

            // Countdown Timer Circle
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.redAccent, width: 8),
              ),
              child: Center(
                child: Text(
                  '$_counter',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Informative text and Cancel button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Sending location will start after countdown. Click cancel to exit.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel action
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
    );
  }
}
