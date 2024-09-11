import 'package:flutter/material.dart';
import 'create_feedback_screen.dart';
import 'read_feedback_screen.dart';
import 'update_feedback_screen.dart';
import 'delete_feedback_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Buttons in a grid format
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(20.0),
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
            const SizedBox(height: 30),
            // Microphone icon at the bottom
            _buildMicrophoneIcon(),
          ],
        ),
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.mic,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}
