import 'package:flutter/material.dart';
import 'create_feedback_screen.dart';
import 'read_feedback_screen.dart';
import 'update_feedback_screen.dart';
import 'delete_feedback_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Grid of buttons with fixed height and spacing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildNavigationButton(
                    context, Icons.add, "Create", CreateFeedbackScreen()),
                _buildNavigationButton(
                    context, Icons.edit, "Update", UpdateFeedbackScreen()),
                _buildNavigationButton(
                    context, Icons.delete, "Delete", DeleteFeedbackScreen()),
                _buildNavigationButton(
                    context, Icons.list, "Read", ReadFeedbackScreen()),
              ],
            ),
          ),
          const SizedBox(height: 30), // Space between grid and microphone
          // Divider as seen in the image
          const Divider(
            thickness: 2.0,
            indent: 50,
            endIndent: 50,
          ),
          const SizedBox(height: 20),
          // Microphone icon at the bottom, centered
          _buildMicrophoneIcon(),
          const SizedBox(height: 20), // Padding below the microphone
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, IconData icon, String label, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(15), // More rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicrophoneIcon() {
    return GestureDetector(
      onTap: () {
        // Microphone on tap functionality
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(60), // Circular button
        ),
        child: const Icon(
          Icons.mic,
          color: Colors.white,
          size: 60, // Larger icon for emphasis
        ),
      ),
    );
  }
}
