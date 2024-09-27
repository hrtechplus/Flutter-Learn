import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  bool _isListening = false;
  String _commandText = "";

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText(); // Initialize speech recognition
  }

  // Start listening for voice commands
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speechToText.listen(onResult: (result) {
          setState(() {
            _commandText = result.recognizedWords;
          });
          _executeCommand(_commandText);
        });
      } else {
        // Handle the case where speech recognition is not available
        print("Speech recognition not available");
      }
    }
  }

  // Stop listening for voice commands
  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  // Execute the command based on recognized words
  void _executeCommand(String command) {
    command = command.toLowerCase(); // Convert to lowercase for easy comparison

    if (command.contains("create feedback")) {
      _navigateToScreen(CreateFeedbackScreen());
    } else if (command.contains("read feedbacks")) {
      _navigateToScreen(ReadFeedbackScreen());
    } else if (command.contains("edit feedbacks")) {
      _navigateToScreen(const UpdateFeedbackScreen());
    } else if (command.contains("delete feedbacks")) {
      _navigateToScreen(DeleteFeedbackScreen());
    } else {
      // Command not recognized, show message or take alternative action
      print("Command not recognized");
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
                    context, Icons.add, "Add", CreateFeedbackScreen()),
                _buildNavigationButton(
                    context, Icons.edit, "Edit", const UpdateFeedbackScreen()),
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
      onTap: _isListening
          ? _stopListening
          : _startListening, // Start or stop listening
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: _isListening
              ? Colors.green
              : Colors.redAccent, // Change color when listening
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
    );
  }
}
