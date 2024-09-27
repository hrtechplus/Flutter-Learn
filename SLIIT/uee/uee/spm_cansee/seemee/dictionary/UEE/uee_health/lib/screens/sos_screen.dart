import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'countdown_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  String _currentLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [Permission.location, Permission.sms].request();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = "${position.latitude}, ${position.longitude}";
    });
  }

  void _startCountdown() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CountdownScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Hold the SOS button for 3 seconds if you're in an emergency.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            GestureDetector(
              onLongPress: _startCountdown,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.red],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "SOS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Your Location: $_currentLocation"),
          ],
        ),
      ),
    );
  }
}
