import 'package:flutter/material.dart';
import 'dart:async';
import 'confirmation_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CountdownScreen extends StatefulWidget {
  final String location;

  const CountdownScreen({super.key, required this.location});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _counter = 3;
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
        _onCountdownFinished();
      }
    });
  }

  void _onCountdownFinished() {
    String message =
        "SOS Emergency! I need help. My current location is: ${widget.location}";
    _sendSMS(message);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(location: widget.location),
      ),
    );
  }

  void _sendSMS(String message) async {
    String smsUrl = "sms:+1234567890?body=$message"; // Replace with actual number
    if (await canLaunch(smsUrl)) {
      await launch(smsUrl);
    } else {
      throw 'Could not launch SMS';
    }
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
      body: Center(
        child: Text(
          '$_counter',
          style: const TextStyle(
            fontSize: 100,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
