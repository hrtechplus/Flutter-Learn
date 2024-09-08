// lib/screens/sos_screen.dart
import 'package:flutter/material.dart';
import 'package:uee_eme/services/emergency_service.dart'; // Import the emergency service

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("SOS"),
        onPressed: () {
          EmergencyService.sendEmergencySignal();
        },
      ),
    );
  }
}
