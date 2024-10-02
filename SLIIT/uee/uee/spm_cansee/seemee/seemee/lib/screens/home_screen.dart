import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart'; // For vibration feedback
import 'package:flutter/services.dart'; // For haptic feedback
import 'create_feedback_screen.dart';
import 'read_feedback_screen.dart';
import 'update_feedback_screen.dart';
import 'delete_feedback_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late stt.SpeechToText _speechToText;
  bool _isListening = false; // Tracks if the app is in listening mode
  String _commandText = "";

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText(); // Initialize speech recognition
  }

  // Start listening for voice commands with vibration and haptic feedback
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });

        // Trigger vibration and haptic feedback
        _triggerVibrationAndHaptic();

        _speechToText.listen(onResult: (result) {
          setState(() {
            _commandText = result.recognizedWords;
          });
        });
      } else {
        // Handle the case where speech recognition is not available
        print("Speech recognition not available");
      }
    }
  }

  // Stop listening, process the command, and provide feedback
  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });

      // Check if a valid command was captured
      if (_commandText.isNotEmpty) {
        _executeCommand(_commandText);
      } else {
        // Trigger a long vibration if no command was captured
        _triggerFailureVibration();
      }
    }
  }

  // Execute the command based on recognized words
  void _executeCommand(String command) {
    command = command.toLowerCase(); // Convert to lowercase for easy comparison

    if (command.contains("create feedback")) {
      _navigateToScreen(CreateFeedbackScreen());
    } else if (command.contains("read feedback")) {
      _navigateToScreen(ReadFeedbackScreen());
    } else if (command.contains("edit feedback")) {
      _navigateToScreen(const UpdateFeedbackScreen());
    } else if (command.contains("delete feedback")) {
      _navigateToScreen(DeleteFeedbackScreen());
    } else {
      // Command not recognized, provide feedback
      print("Command not recognized");
      _triggerFailureVibration();
    }
  }

  // Trigger vibration and haptic feedback
  void _triggerVibrationAndHaptic() async {
    // Provide haptic feedback
    HapticFeedback.mediumImpact();

    // Provide vibration feedback (if available)
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 200); // Vibrate for 200ms
    }
  }

  // Trigger long vibration for failure in command capture
  void _triggerFailureVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000); // Long vibration for 1000ms
    }
  }

  // Method to navigate to a specific screen
  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      // When user starts long press, start listening
      onLongPressStart: (details) {
        _startListening();
      },

      // When user releases the long press, stop listening and process the result
      onLongPressEnd: (details) {
        _stopListening();
      },

      child: Scaffold(
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
                      context, Icons.add, "Add", CreateFeedbackScreen()),
                  _buildNavigationButton(context, Icons.edit, "Edit",
                      const UpdateFeedbackScreen()),
                  _buildNavigationButton(
                      context, Icons.delete, "Delete", DeleteFeedbackScreen()),
                  _buildNavigationButton(
                      context, Icons.list, "Show", ReadFeedbackScreen()),
                ],
              ),
            ),
            const SizedBox(height: 30), // Space between grid and microphone
            const Divider(
              thickness: 2.0,
              indent: 50,
              endIndent: 50,
            ),
            const SizedBox(height: 20),

            // Microphone icon to show current listening status
            GestureDetector(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _isListening
                      ? Colors.redAccent // Mic icon turns red while listening
                      : Colors.blueAccent, // Default is blueAccent
                  borderRadius: BorderRadius.circular(60), // Circular button
                ),
                child: Icon(
                  _isListening
                      ? Icons.mic
                      : Icons.mic_none, // Change icon when listening
                  color: Colors.white,
                  size: 60, // Larger icon for emphasis
                ),
              ),
            ),

            const SizedBox(height: 20), // Padding below the microphone
          ],
        ),
      ),
    );
  }

  // Build the navigation buttons for each screen
  Widget _buildNavigationButton(
      BuildContext context, IconData icon, String label, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent, // Changed color to BlueAccent
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
}
