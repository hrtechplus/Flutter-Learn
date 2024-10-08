import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'home_screen.dart'; // Import HomeScreen for navigation

class DeleteFeedbackScreen extends StatefulWidget {
  const DeleteFeedbackScreen({super.key});

  @override
  _DeleteFeedbackScreenState createState() => _DeleteFeedbackScreenState();
}

class _DeleteFeedbackScreenState extends State<DeleteFeedbackScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  late CollectionReference feedbacks;
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _commandText = "";

  @override
  void initState() {
    super.initState();
    feedbacks = FirebaseFirestore.instance.collection('feedbacks');
    _speechToText = stt.SpeechToText(); // Initialize _speechToText
    _announcePage(); // Announce that we are on the Delete Feedback page
  }

  // Announce the page using Text-to-Speech (TTS)
  void _announcePage() async {
    await _flutterTts.speak("You are in the Delete Feedback page.");
  }

  // Method to read the feedback out loud using TTS
  void _readFeedback(String feedbackText) async {
    await _flutterTts.speak("Your feedback is: $feedbackText");
  }

  // Method to confirm and delete feedback
  void _confirmAndDeleteFeedback(String feedbackId) async {
    await _flutterTts.speak("Are you sure you want to delete this feedback?");
    await _deleteFeedback(feedbackId);
  }

  // Method to delete feedback
  Future<void> _deleteFeedback(String feedbackId) async {
    try {
      await feedbacks.doc(feedbackId).delete();
      await _flutterTts.speak("Your feedback has been deleted.");
    } catch (e) {
      await _flutterTts.speak("Failed to delete feedback.");
    }
  }

  // Method to format date and time
  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – kk:mm').format(date);
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
        await _flutterTts.speak("Speech recognition is not available.");
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

  // Execute command based on recognized voice input
  void _executeCommand(String command) {
    if (command.toLowerCase().contains("delete")) {
      _flutterTts.speak("Deleting feedback.");
      // Logic for deleting feedback could be added here
    } else {
      _flutterTts.speak("Command not recognized.");
    }
  }

  // Handle swipe gestures to go back to HomeScreen
  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      _flutterTts.speak("Back to HomeScreen");
      // Swipe right (go back)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (details.primaryVelocity! < 0) {
      _flutterTts.speak("Back to HomeScreen");
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
      // Handle swipe gestures
      onHorizontalDragEnd: _handleSwipe,

      // Handle long press to start listening for commands
      onLongPress: _startListening,

      // Handle double tap to delete feedback (for demo purposes)
      onDoubleTap: () {
        // Example: Simulate a deletion action
        if (_commandText.isNotEmpty) {
          _flutterTts.speak("Double tap detected. Deleting feedback.");
        }
      },

      child: Scaffold(
        appBar: AppBar(title: const Text('Delete Feedback')),
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
                        String feedbackText =
                            document['feedback'] ?? 'No feedback provided';
                        String feedbackId = document.id;
                        Timestamp timestamp =
                            document['timestamp'] ?? Timestamp.now();

                        // Format the timestamp to show both date and time
                        String formattedDateTime = _formatTimestamp(timestamp);

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(feedbackText.length > 20
                                ? "${feedbackText.substring(0, 20)}..."
                                : feedbackText), // Dynamic title from feedback
                            subtitle: Text(
                                formattedDateTime), // Dynamic date and time
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  color: Colors.green,
                                  onPressed: () => _readFeedback(
                                      feedbackText), // Read feedback
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.redAccent,
                                  onPressed: () => _confirmAndDeleteFeedback(
                                      feedbackId), // Confirm and delete
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              // Add a microphone button at the bottom for voice commands
              const Divider(),
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.green : Colors.redAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
