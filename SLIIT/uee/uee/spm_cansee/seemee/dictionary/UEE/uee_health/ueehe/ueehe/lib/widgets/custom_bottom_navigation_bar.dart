import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,

      height: 60.0,

      backgroundColor:
          Colors.transparent, // Keeps it transparent to reveal body content
      color: Colors.redAccent, // Background color of the curved bar
      buttonBackgroundColor: Colors.red, // Color of the center button
      animationDuration:
          const Duration(milliseconds: 300), // Animation duration
      animationCurve: Curves.easeInOut, // Animation curve for smooth effect
      onTap: onTabSelected, // Handle tab changes
      items: const [
        Icon(Icons.warning_rounded, size: 30, color: Colors.white),
        Icon(Icons.history_edu_rounded, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
    );
  }
}
