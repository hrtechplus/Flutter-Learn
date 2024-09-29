import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/custom_bottom_navigation_bar.dart'; // Import the custom navigation bar
import 'profile_screen.dart';
import 'history_screen.dart';
import 'countdown_screen.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  String _currentLocation = "Fetching location...";
  double? _latitude;
  double? _longitude;

  int _selectedIndex = 0; // Current tab index for BottomNavigationBar

  // List of screens for each tab
  final List<Widget> _screens = [];

  late AnimationController
      _controller; // Controller for the breathing animation
  late Animation<double> _animation; // Animation value for scaling

  @override
  void initState() {
    super.initState();

    // Initialize the screens for bottom navigation
    _screens.add(SosScreenContent(
      location: _currentLocation,
      onEmergencyPressed: _startEmergencyProcedure,
    ));
    _screens.add(HistoryScreen()); // History Screen (Second Tab)
    _screens.add(ProfileScreen()); // Profile Screen (Third Tab)

    _requestPermissions();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duration for one breathing cycle
    )..repeat(reverse: true); // Repeat the animation (breathing effect)

    // Tween to scale between 0.9x and 1.0x
    _animation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
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
        // Update the SosScreenContent with the new location
        _screens[0] = SosScreenContent(
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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex, // Pass the current index
        onTabSelected: _onTabSelected, // Pass the tab selection callback
      ),
    );
  }
}

// SosScreenContent widget with pulsing animation for SOS button
class SosScreenContent extends StatefulWidget {
  final VoidCallback onEmergencyPressed;
  final String location;

  SosScreenContent({required this.onEmergencyPressed, required this.location});

  @override
  _SosScreenContentState createState() => _SosScreenContentState();
}

class _SosScreenContentState extends State<SosScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this, // Ticker provider for the animation
      duration: const Duration(seconds: 1), // Duration for one breathing cycle
    )..repeat(
        reverse:
            true); // Repeat the animation in reverse for the breathing effect

    // Define the animation tween (scale between 0.9 and 1.0)
    _animation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

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
        // Breathing SOS button with animation
        GestureDetector(
          onLongPress: widget.onEmergencyPressed,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value, // Apply the scaling from animation
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
              );
            },
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
                      widget.location,
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
