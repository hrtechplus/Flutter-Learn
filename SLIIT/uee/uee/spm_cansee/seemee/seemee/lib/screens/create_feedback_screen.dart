import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:vibration/vibration.dart'; // Vibration package
import 'home_screen.dart'; // Import the HomeScreen

class CreateFeedbackScreen extends StatefulWidget {
  const CreateFeedbackScreen({super.key});

  @override
  _CreateFeedbackScreenState createState() => _CreateFeedbackScreenState();
}

class _CreateFeedbackScreenState extends State<CreateFeedbackScreen> {
  late stt.SpeechToText speechToText; // Speech to text instance
  bool isListening = false; // Track if speech recognition is listening
  bool _speechAvailable = false; // To check if speech recognition is available
  final TextEditingController _feedbackController =
      TextEditingController(); // To capture text input
  late FlutterTts flutterTts; // For Text-to-Speech

  @override
  void initState() {
    super.initState();
    _initSpeech(); // Initialize Speech-to-Text
    _initTTS(); // Initialize Text-to-Speech
  }

  // Initialize Speech to Text
  void _initSpeech() async {
    speechToText = stt.SpeechToText();

    // Initialize the speech recognition and check if it's available
    _speechAvailable = await speechToText.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (_speechAvailable) {
      print("Speech recognition is available.");
    } else {
      print("Speech recognition is not available.");
    }

    setState(() {});
  }

  // Initialize Text-to-Speech (TTS)
  void _initTTS() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    _speakPrompt(); // Automatically speak the message when the page appears
  }

  // Speak the prompt when the page appears
  void _speakPrompt() async {
    await flutterTts.speak(
        "You are in the Feedback menu. Long press anywhere on the screen to start recording, and double tap anywhere to send feedback.");
  }

  // Start vibration and haptic feedback when recording starts
  void _vibrateAndHaptic() async {
    HapticFeedback.mediumImpact(); // Provide medium haptic feedback

    // Check if vibration is available and trigger it
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 200); // Vibrate for 200ms
    }
  }

  // Method to start listening (Speech-to-Text) for feedback
  void _startListening() async {
    // Check if speech recognition is available
    if (_speechAvailable && !isListening) {
      print("Starting to listen...");
      setState(() {
        isListening = true;
      });

      _vibrateAndHaptic(); // Trigger haptic and vibration feedback when listening starts

      // Start listening to speech and update the text as recognized
      await speechToText.listen(
        onResult: (result) {
          setState(() {
            // Update the feedback controller with recognized words
            _feedbackController.text = result.recognizedWords;
          });
          print("Recognized Words: ${result.recognizedWords}");
        },
        listenFor: const Duration(seconds: 10), // How long to listen
        pauseFor: const Duration(seconds: 5), // Pause listening if silence
        partialResults: true, // Allow partial results
      );
    } else {
      print("Speech recognition not available or already listening.");
    }
  }

  // Method to stop listening (Speech-to-Text) and provide haptic feedback
  void _stopListening() async {
    if (isListening) {
      print("Stopping listening...");
      await speechToText.stop();
      setState(() {
        isListening = false;
      });

      HapticFeedback
          .lightImpact(); // Provide light haptic feedback when stopping
    }
  }

  // Save feedback to Firebase
  Future<void> _saveFeedback() async {
    try {
      // Get the feedback text from the TextField
      String feedbackText = _feedbackController.text;

      if (feedbackText.isNotEmpty) {
        // Get current date and time in a readable format
        String formattedDateTime = DateFormat('yyyy-MM-dd – HH:mm:ss')
            .format(DateTime.now()); // Example: 2024-09-10 – 14:30:45

        // Add the feedback along with timestamp and formatted date/time
        CollectionReference feedbacks =
            FirebaseFirestore.instance.collection('feedbacks');

        await feedbacks.add({
          'feedback': feedbackText, // The feedback text
          'timestamp': FieldValue.serverTimestamp(), // Server timestamp
          'dateTime': formattedDateTime, // Human-readable date/time
        });

        _vibrateSuccess(); // Vibration feedback for success

        // Provide TTS feedback for success
        await flutterTts.speak("Feedback sent successfully.");

        // Debugging print statement to verify saving process
        print("Feedback saved: $feedbackText on $formattedDateTime");

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback saved successfully!')),
        );

        // Clear the text field after saving
        _feedbackController.clear();
      } else {
        _vibrateError(); // Vibration feedback for error

        // Provide TTS feedback for empty feedback
        await flutterTts.speak("Feedback text cannot be empty.");

        // Show error message if the text field is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback text cannot be empty!')),
        );
      }
    } catch (e) {
      // Handle errors
      _vibrateError(); // Vibration feedback for error

      // Provide TTS feedback for failure
      await flutterTts.speak("Failed to send feedback.");

      print("Error saving feedback: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save feedback: $e')),
      );
    }
  }

  // Custom vibration for success feedback
  void _vibrateSuccess() async {
    HapticFeedback.heavyImpact();
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 300); // Short single vibration for success
    }
  }

  // Custom vibration for error feedback
  void _vibrateError() async {
    HapticFeedback.heavyImpact();
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
          pattern: [0, 200, 100, 200]); // Double vibration for error
    }
  }

  // Handle swipe back to HomeScreen
  Future<void> _handleSwipe(DragEndDetails details) async {
    if (details.primaryVelocity! > 0) {
      // Swipe Right
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      // Provide TTS feedback for failure
      await flutterTts.speak("Back to HomeScreen");
    } else if (details.primaryVelocity! < 0) {
      // Swipe Left
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      await flutterTts.speak("Back to HomeScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onHorizontalDragEnd: _handleSwipe, // Detect swipe left or right
      onLongPress:
          _startListening, // Start listening for feedback on long press
      onDoubleTap: _saveFeedback, // Send feedback on double tap
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Feedback"),
        ),
        body: Column(
          children: [
            // Top 50% of the screen for feedback display
            Container(
              height: screenHeight * 0.5, // Top 50% of the screen
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  _feedbackController.text.isNotEmpty
                      ? _feedbackController.text
                      : "Your feedback will appear here...",
                  style: const TextStyle(
                      fontSize: 20), // Larger font size for readability
                ),
              ),
            ),

            // Bottom 50% of the screen for buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Microphone button for recording feedback
                    GestureDetector(
                      onTap: isListening ? _stopListening : _startListening,
                      child: Container(
                        height: screenHeight *
                            0.2, // Large button, 20% of screen height
                        width: screenHeight * 0.2, // Make button square
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius:
                              BorderRadius.circular(20), // Rounded edges
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mic,
                              size: 60, // Larger icon for accessibility
                              color: Colors.blueAccent,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Record Feedback",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),

                    // Button for sending feedback
                    GestureDetector(
                      onTap: _saveFeedback,
                      child: Container(
                        height: screenHeight *
                            0.2, // Large button, 20% of screen height
                        width: screenHeight * 0.2, // Make button square
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius:
                              BorderRadius.circular(20), // Rounded edges
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send,
                              size: 60, // Larger icon for accessibility
                              color: Colors.blueAccent,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Send Feedback",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
