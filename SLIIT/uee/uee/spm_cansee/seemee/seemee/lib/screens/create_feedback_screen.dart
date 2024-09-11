import 'package:flutter/material.dart';

class CreateFeedbackScreen extends StatefulWidget {
  @override
  _CreateFeedbackScreenState createState() => _CreateFeedbackScreenState();
}

class _CreateFeedbackScreenState extends State<CreateFeedbackScreen> {
  String feedbackText = "The session science session was good.....";
  bool isListening = false;

  void startListening() {
    setState(() {
      isListening = true;
    });

    // Add your speech-to-text logic here, and when done, update the feedback text

    Future.delayed(Duration(seconds: 3), () {
      // Simulate text input from speech
      setState(() {
        feedbackText =
            "Listening completed!"; // Replace this with the actual recognized speech
        isListening = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Feedback display text box
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                feedbackText,
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),

            // Microphone button
            GestureDetector(
              onTap: startListening,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isListening ? "Listening.." : "Tap to Speak",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
