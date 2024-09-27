import 'package:flutter/material.dart';
import 'emergency_active_screen.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

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
        _vibrateAndNavigate();
      }
    });
  }

  Future<void> _vibrateAndNavigate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EmergencyActiveScreen()),
    );
  }

  void _cancelCountdown() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$_counter',
            style: const TextStyle(fontSize: 100, color: Colors.red),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _cancelCountdown,
            child: const Text("Cancel"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
