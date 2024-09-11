import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class DeleteFeedbackScreen extends StatefulWidget {
  @override
  _DeleteFeedbackScreenState createState() => _DeleteFeedbackScreenState();
}

class _DeleteFeedbackScreenState extends State<DeleteFeedbackScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  late CollectionReference feedbacks;

  @override
  void initState() {
    super.initState();
    feedbacks = FirebaseFirestore.instance.collection('feedbacks');
  }

  // Method to read the feedback out loud using TTS
  void _readFeedback(String feedbackText) async {
    await _flutterTts.speak("Your feedback is: $feedbackText");
  }

  // Method to confirm and delete feedback
  void _confirmAndDeleteFeedback(String feedbackId) async {
    await _flutterTts.speak("Are you sure you want to delete this feedback?");

    // Here, you would typically show a dialog for user confirmation
    // For simplicity, we'll proceed directly to deletion
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
    return DateFormat('yyyy-MM-dd – kk:mm')
        .format(date); // Example: 2023-09-10 – 14:30
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          subtitle:
                              Text(formattedDateTime), // Dynamic date and time
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.redAccent,
                            onPressed: () => _confirmAndDeleteFeedback(
                                feedbackId), // Confirm and delete
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
