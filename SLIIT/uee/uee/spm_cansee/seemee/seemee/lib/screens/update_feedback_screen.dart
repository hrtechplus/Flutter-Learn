import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/feedback_service.dart';

class UpdateFeedbackScreen extends StatefulWidget {
  const UpdateFeedbackScreen({super.key});

  @override
  _UpdateFeedbackScreenState createState() => _UpdateFeedbackScreenState();
}

class _UpdateFeedbackScreenState extends State<UpdateFeedbackScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final FeedbackService _feedbackService = FeedbackService();
  String _updatedFeedback = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Feedback')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _updateFeedback,
              child: const Text('Update Feedback'),
            ),
            Text(_updatedFeedback),
          ],
        ),
      ),
    );
  }

  void _updateFeedback() async {
    await _flutterTts.speak("Please provide your updated feedback.");
    setState(() {
      _updatedFeedback = "Updated feedback goes here.";
      _feedbackService.updateFeedback(_updatedFeedback);
    });
    await _flutterTts.speak("Your feedback has been updated.");
  }
}
