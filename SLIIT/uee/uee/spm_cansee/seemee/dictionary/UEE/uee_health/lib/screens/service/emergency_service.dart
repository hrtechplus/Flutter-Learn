import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmergencyService {
  static Future<void> sendEmergencySMS(String message) async {
    try {
      await sendSMS(message: message, recipients: ["+1234567890"]);
    } catch (error) {
      print("Failed to send SMS: $error");
    }
  }

  static Future<void> sendEmergencyEmail(String subject, String body) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: ["emergency@example.com"],
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print("Failed to send Email: $error");
    }
  }
}
