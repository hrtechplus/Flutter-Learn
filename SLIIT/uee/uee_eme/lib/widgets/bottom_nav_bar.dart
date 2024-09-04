// lib/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:uee_eme/screens/profile_screen.dart';
import 'package:uee_eme/screens/sos_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ProfileScreen(), // Assuming ProfileScreen is another widget you've created
    SOSScreen(), // Assuming SOSScreen is another widget you've created
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'SOS',
          ),
        ],
      ),
    );
  }
}
