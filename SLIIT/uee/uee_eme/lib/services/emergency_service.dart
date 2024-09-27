import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmergencyService {
  // Example emergency contact numbers and emails
  static List<String> emergencyContacts = ["+1234567890"];
  static List<String> emergencyEmails = ["emergency@example.com"];

  // Send SMS
  static Future<void> sendEmergencySMS(String message) async {
    try {
      await sendSMS(message: message, recipients: emergencyContacts);
      print("Emergency SMS sent!");
    } catch (error) {
      print("Failed to send SMS: $error");
    }
  }

  // Send Email
  static Future<void> sendEmergencyEmail(String subject, String body) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: emergencyEmails,
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
      print("Emergency email sent!");
    } catch (error) {
      print("Failed to send Email: $error");
    }
  }
}
