import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart'; // For date formatting
import 'FeedbackReportScreen.dart';
import 'feedback_report_screen.dart'; // Import the report screen
import 'home_screen.dart'; // Import HomeScreen for navigation

import 'create_feedback_screen.dart';
import 'update_feedback_screen.dart';
import 'delete_feedback_screen.dart';

class ReadFeedbackScreen extends StatefulWidget {
  const ReadFeedbackScreen({super.key});

  @override
  _ReadFeedbackScreenState createState() => _ReadFeedbackScreenState();
}

class _ReadFeedbackScreenState extends State<ReadFeedbackScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  late CollectionReference feedbacks;
  late stt.SpeechToText _speechToText; // Speech-to-text instance
  bool _isListening = false;
  String _commandText = "";
  bool _speechEnabled = false; // Flag to check if speech-to-text is available

  @override
  void initState() {
    super.initState();
    feedbacks = FirebaseFirestore.instance.collection('feedbacks');
    _initSpeechToText(); // Initialize the speech-to-text functionality
    _announcePage(); // Announce the page with TTS
  }

  // Announce the page using Text-to-Speech (TTS)
  void _announcePage() async {
    await _flutterTts.speak("You are in the Read Feedback page.");
  }

  // Initialize the speech-to-text functionality
  void _initSpeechToText() async {
    _speechToText = stt.SpeechToText(); // Initialize the instance
    _speechEnabled = await _speechToText.initialize();
    setState(() {}); // Update UI based on the initialization result
  }

  // Method to read the feedback out loud using TTS
  void _readFeedback(String feedbackText) async {
    await _flutterTts.speak("Your feedback is: $feedbackText");
  }

  // Method to format date and time
  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – kk:mm')
        .format(date); // Example: 2023-09-10 – 14:30
  }

  // Generate a dynamic title from the feedback text
  String _generateTitle(String feedbackText) {
    // Take the first 20 characters or less to create a dynamic title
    return feedbackText.length > 20
        ? "${feedbackText.substring(0, 20)}..."
        : feedbackText;
  }

  // Start listening for voice commands
  void _startListening() async {
    if (_speechEnabled && !_isListening) {
      // Only start if speech-to-text is initialized
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
      print("Speech recognition not available");
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

  // Execute command based on recognized voice input
  void _executeCommand(String command) {
    command = command.toLowerCase(); // Normalize command to lowercase

    // Custom command processing logic
    if (command.contains("create")) {
      _navigateToScreen(CreateFeedbackScreen());
    } else if (command.contains("read")) {
      _navigateToScreen(ReadFeedbackScreen());
    } else if (command.contains("update")) {
      _navigateToScreen(const UpdateFeedbackScreen());
    } else if (command.contains("delete")) {
      _navigateToScreen(DeleteFeedbackScreen());
    } else {
      // Command not recognized, show message or take alternative action
      print("Command not recognized");
    }
  }

  // Navigate to the corresponding screen
  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Navigate to report screen
  void _navigateToReport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackReportScreen()),
    );
  }

  // Handle swipe gestures to go back to HomeScreen
  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      // Swipe right (go back)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (details.primaryVelocity! < 0) {
      // Swipe left (go back)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Handle swipe gestures to go back
      onHorizontalDragEnd: _handleSwipe,

      // Handle long press to start listening for commands
      onLongPress: _startListening,

      // Handle double tap to simulate voice command (optional)
      onDoubleTap: () {
        if (_commandText.isNotEmpty) {
          _flutterTts.speak("Double tap detected. Processing command.");
        }
      },

      child: Scaffold(
        appBar: AppBar(title: const Text('Read Feedback')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display feedback list (dynamic)
              Expanded(
                child: StreamBuilder(
                  stream: feedbacks
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((document) {
                        // Check if feedback exists and handle potential null cases
                        String feedbackText =
                            document['feedback'] ?? 'No feedback provided';
                        Timestamp timestamp =
                            document['timestamp'] ?? Timestamp.now();

                        // Dynamically generate a title and format the timestamp
                        String feedbackTitle = _generateTitle(feedbackText);
                        String formattedDateTime = _formatTimestamp(timestamp);

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                                feedbackTitle), // Dynamic title from feedback
                            subtitle: Text(
                                formattedDateTime), // Dynamic date and time
                            trailing: IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () => _readFeedback(
                                  feedbackText), // Read the feedback aloud
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              // Microphone button at the bottom
              const Divider(),
              GestureDetector(
                onTap: _isListening
                    ? _stopListening
                    : _startListening, // Start or stop listening
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: _isListening
                            ? Colors.green
                            : Colors.blueAccent, // Change color when listening
                        borderRadius:
                            BorderRadius.circular(75), // Rounded circle
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 70, // Larger icon for accessibility
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Listening...",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Add the report button for non-visually impaired users
// Inside your ReadFeedbackScreen class
              ElevatedButton(
                onPressed: _navigateToReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Background color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15), // Padding for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Fully rounded corners
                  ),
                ),
                child: const Text(
                  "Show Report",
                  style: TextStyle(
                    color: Colors.white, // Text color white
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold, // Bold font
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
