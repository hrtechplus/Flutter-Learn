import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart'; // For date formatting
import 'home_screen.dart'; // Import HomeScreen for navigation

class UpdateFeedbackScreen extends StatefulWidget {
  const UpdateFeedbackScreen({super.key});

  @override
  _UpdateFeedbackScreenState createState() => _UpdateFeedbackScreenState();
}

class _UpdateFeedbackScreenState extends State<UpdateFeedbackScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  late CollectionReference feedbacks;
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _commandText = "";
  final TextEditingController _updatedFeedbackController =
      TextEditingController(); // Controller to hold the updated feedback

  @override
  void initState() {
    super.initState();
    feedbacks = FirebaseFirestore.instance.collection('feedbacks');
    _speechToText = stt.SpeechToText(); // Initialize Speech to Text
    _announcePage(); // Announce that we are on the Update Feedback page
  }

  // Announce the page using Text-to-Speech (TTS)
  void _announcePage() async {
    await _flutterTts.speak("You are in the Update Feedback page.");
  }

  // Start listening for voice input
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speechToText.listen(onResult: (result) {
          setState(() {
            _updatedFeedbackController.text = result.recognizedWords;
          });
        });
      } else {
        await _flutterTts.speak("Speech recognition is not available.");
      }
    }
  }

  // Stop listening
  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  // Update feedback in Firebase
  Future<void> _updateFeedback(String feedbackId) async {
    try {
      String updatedFeedbackText = _updatedFeedbackController.text;

      if (updatedFeedbackText.isNotEmpty) {
        await feedbacks.doc(feedbackId).update({
          'feedback': updatedFeedbackText, // Update the feedback text
        });

        // Provide TTS feedback for success
        await _flutterTts.speak("Feedback updated successfully.");

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback updated successfully!')),
        );

        Navigator.pop(context); // Go back after successful update
      } else {
        // Provide TTS feedback for empty feedback
        await _flutterTts.speak("Updated feedback text cannot be empty.");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback text cannot be empty!')),
        );
      }
    } catch (e) {
      // Provide TTS feedback for failure
      await _flutterTts.speak("Failed to update feedback.");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update feedback: $e')),
      );
    }
  }

  // Method to format date and time
  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – kk:mm').format(date);
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

      // Handle double tap to update feedback (for demo purposes)
      onDoubleTap: () {
        if (_updatedFeedbackController.text.isNotEmpty) {
          _flutterTts.speak("Double tap detected. Updating feedback.");
        }
      },

      child: Scaffold(
        appBar: AppBar(title: const Text('Update Feedback')),
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
                        Timestamp timestamp =
                            document['timestamp'] ?? Timestamp.now();
                        String formattedDateTime = _formatTimestamp(timestamp);
                        String feedbackId = document.id;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(feedbackText.length > 20
                                ? "${feedbackText.substring(0, 20)}..."
                                : feedbackText),
                            subtitle: Text(formattedDateTime),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () {
                                // Populate the TextField with the selected feedback text
                                _updatedFeedbackController.text = feedbackText;
                                // Show a dialog to edit the feedback
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Update Feedback'),
                                      content: TextField(
                                        controller: _updatedFeedbackController,
                                        decoration: const InputDecoration(
                                          hintText: "Edit your feedback",
                                        ),
                                        maxLines: 3,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _updateFeedback(feedbackId);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Update'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const Divider(),
              // Microphone button to start/stop listening
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
