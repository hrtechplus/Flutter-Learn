import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'profile_screen.dart';
import 'history_screen.dart';
import 'countdown_screen.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  String _currentLocation = "Fetching location...";
  double? _latitude;
  double? _longitude;

  int _selectedIndex = 0; // Current tab index for BottomNavigationBar

  // List of screens for each tab
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(SosHomeScreen(
      location: _currentLocation,
      onEmergencyPressed: _startEmergencyProcedure,
    )); // SOS Home Screen
    _screens.add(ProfileScreen()); // Profile Screen
    _screens.add(HistoryScreen()); // History Screen
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var locationPermission = await Permission.location.request();

    if (locationPermission.isGranted) {
      _determinePosition();
    } else {
      setState(() {
        _currentLocation = "Location permissions are denied.";
      });
    }
  }

  Future<void> _determinePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = "${position.latitude}, ${position.longitude}";
        _latitude = position.latitude;
        _longitude = position.longitude;
        // Update the SosHomeScreen with the new location
        _screens[0] = SosHomeScreen(
          location: _currentLocation,
          onEmergencyPressed: _startEmergencyProcedure,
        );
      });
    } catch (e) {
      setState(() {
        _currentLocation = "Failed to fetch location: $e";
      });
    }
  }

  // Method to start the emergency procedure
  void _startEmergencyProcedure() {
    if (_latitude != null && _longitude != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountdownScreen(
            location: _currentLocation,
            latitude: _latitude!,
            longitude: _longitude!,
          ),
        ),
      );
    } else {
      // Handle the case where the location is not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to fetch location")),
      );
    }
  }

  // Method to handle tab selection in the bottom navigation bar
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex], // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Track the selected tab index
        onTap: _onTabSelected, // Update the tab when user taps
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_rounded),
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// A new SosHomeScreen widget that uses the emergency button and location
class SosHomeScreen extends StatelessWidget {
  final VoidCallback onEmergencyPressed;
  final String location;

  SosHomeScreen({required this.onEmergencyPressed, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, size: 28, color: Colors.black54),
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
              IconButton(
                icon: const Icon(Icons.notifications_none,
                    size: 28, color: Colors.redAccent),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Are you in an emergency?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            "Hold the SOS button for a while, the urgent situation will start soon.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onLongPress: onEmergencyPressed,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
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
        const SizedBox(height: 40),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(FontAwesomeIcons.mapMarkerAlt,
                  color: Colors.redAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your current location",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
