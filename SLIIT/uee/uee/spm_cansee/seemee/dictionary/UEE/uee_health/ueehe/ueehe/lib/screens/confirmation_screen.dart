import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmationScreen extends StatelessWidget {
  final String location;

  const ConfirmationScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "SOS Message Sent",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Location sent: $location",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Return to Home",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _makeEmergencyCall,
              icon: const Icon(Icons.phone),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: const Text(
                "Call Emergency Services",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _makeEmergencyCall() async {
    const emergencyNumber = 'tel:911'; // Example emergency number
    if (await canLaunch(emergencyNumber)) {
      await launch(emergencyNumber);
    } else {
      throw 'Could not launch emergency call';
    }
  }
}
