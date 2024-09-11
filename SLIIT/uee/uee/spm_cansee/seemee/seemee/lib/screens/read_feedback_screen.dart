import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/feedback_service.dart';

class ReadFeedbackScreen extends StatelessWidget {
  final FeedbackService _feedbackService = FeedbackService();
  final FlutterTts _flutterTts = FlutterTts();

  ReadFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Read Feedback')),
      body: Center(
        child: ElevatedButton(
          onPressed: _readFeedback,
          child: const Text('Read My Feedback'),
        ),
      ),
    );
  }

  void _readFeedback() async {
    if (_feedbackService.hasFeedback()) {
      await _flutterTts.speak("Your feedback is: ${_feedbackService.feedback}");
    } else {
      await _flutterTts.speak("No feedback recorded yet.");
    }
  }
}
