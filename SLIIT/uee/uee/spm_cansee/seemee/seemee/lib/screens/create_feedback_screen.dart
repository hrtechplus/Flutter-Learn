import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateFeedbackScreen extends StatefulWidget {
  @override
  _CreateFeedbackScreenState createState() => _CreateFeedbackScreenState();
}

class _CreateFeedbackScreenState extends State<CreateFeedbackScreen> {
  // Controller to get the input text from the TextField
  final TextEditingController _feedbackController = TextEditingController();

  FlutterTts? flutterTts; // Flutter TTS instance
  bool isSpeaking = false;
  bool isListening = false;
  late stt.SpeechToText speechToText; // Speech to text instance
  bool _speechAvailable = false; // To check if speech recognition is available

  @override
  void initState() {
    super.initState();
    _initTts();
    _initSpeech();
  }

  // Initialize TTS settings
  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts?.setLanguage("en-US");
    await flutterTts?.setSpeechRate(0.5); // Adjust speech rate
    await flutterTts?.setVolume(1.0); // Full volume
    await flutterTts?.setPitch(1.0); // Normal pitch

    // Listening to when speech ends
    flutterTts?.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  // Initialize Speech to Text
  void _initSpeech() async {
    speechToText = stt.SpeechToText();
    _speechAvailable = await speechToText.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    setState(() {});
  }

  // Method to start speaking (TTS)
  void _speak() async {
    if (flutterTts == null) return; // Ensure flutterTts is initialized

    if (!isSpeaking) {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts?.speak(
          _feedbackController.text); // Speak out the current feedback text
    }
  }

  // Method to stop speaking (TTS)
  void _stop() async {
    if (flutterTts == null) return; // Ensure flutterTts is initialized

    setState(() {
      isSpeaking = false;
    });
    await flutterTts?.stop();
  }

  // Method to start listening (STT)
  void _startListening() async {
    if (_speechAvailable && !isListening) {
      setState(() {
        isListening = true;
      });

      // Start listening to speech and update the text as recognized
      await speechToText.listen(
        onResult: (result) {
          setState(() {
            _feedbackController.text =
                result.recognizedWords; // Update the TextField
          });
        },
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 5),
        partialResults: true,
      );
    }
  }

  // Method to stop listening (STT)
  void _stopListening() async {
    if (isListening) {
      await speechToText.stop();
      setState(() {
        isListening = false;
      });
    }
  }

  // Save feedback to Firebase
  Future<void> _saveFeedback() async {
    try {
      // Get the feedback text from the TextField
      String feedbackText = _feedbackController.text;

      if (feedbackText.isNotEmpty) {
        CollectionReference feedbacks =
            FirebaseFirestore.instance.collection('feedbacks');

        await feedbacks.add({
          'feedback': feedbackText, // The feedback text
          'timestamp': FieldValue
              .serverTimestamp(), // Timestamp for when feedback was saved
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback saved successfully!')),
        );

        // Clear the text field after saving
        _feedbackController.clear();
      } else {
        // Show error message if the text field is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback text cannot be empty!')),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Feedback input field
            TextField(
              controller:
                  _feedbackController, // Bind the controller to this TextField
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your feedback',
                hintText: 'Enter feedback here...',
              ),
            ),
            const SizedBox(height: 30),

            // Microphone button to trigger STT (listen to user's voice and capture text)
            GestureDetector(
              onTap: isListening ? _stopListening : _startListening,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isListening ? Colors.redAccent : Colors.grey,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isListening ? "Listening..." : "Tap to Speak",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Button to trigger TTS (speak out the feedback text)
            GestureDetector(
              onTap: isSpeaking ? _stop : _speak,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isSpeaking ? Colors.redAccent : Colors.blueGrey,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isSpeaking ? "Speaking..." : "Tap to Listen",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Save feedback to Firebase button
            ElevatedButton(
              onPressed: _saveFeedback,
              child: const Text('Save Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
