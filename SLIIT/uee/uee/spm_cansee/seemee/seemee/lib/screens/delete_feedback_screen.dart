import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/feedback_service.dart';

class DeleteFeedbackScreen extends StatelessWidget {
  final FeedbackService _feedbackService = FeedbackService();
  final FlutterTts _flutterTts = FlutterTts();

  DeleteFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Feedback')),
      body: Center(
        child: ElevatedButton(
          onPressed: _deleteFeedback,
          child: const Text('Delete Feedback'),
        ),
      ),
    );
  }

  void _deleteFeedback() async {
    if (_feedbackService.hasFeedback()) {
      await _flutterTts.speak("Are you sure you want to delete your feedback?");
      // Confirm deletion (you could add another step for confirmation)
      _feedbackService.deleteFeedback();
      await _flutterTts.speak("Your feedback has been deleted.");
    } else {
      await _flutterTts.speak("No feedback to delete.");
    }
  }
}
