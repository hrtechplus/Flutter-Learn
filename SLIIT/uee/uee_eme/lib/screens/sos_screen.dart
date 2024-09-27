import 'package:flutter/material.dart';
import 'package:uee_eme/services/emergency_service.dart';
import 'package:geolocator/geolocator.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  Future<void> _sendEmergencyAlert(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition();
    String locationMessage = "My current location is: "
        "${position.latitude}, ${position.longitude}";

    // SMS message content
    String smsMessage = "EMERGENCY ALERT! I need help. $locationMessage";
    await EmergencyService.sendEmergencySMS(smsMessage);

    // Email content
    String emailBody = "EMERGENCY ALERT!\n\n"
        "I need help immediately.\n\n"
        "My current location is: ${position.latitude}, ${position.longitude}.";
    await EmergencyService.sendEmergencyEmail("Emergency Alert", emailBody);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Emergency alerts sent!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("SOS"),
          onPressed: () => _sendEmergencyAlert(context),
        ),
      ),
    );
  }
}
