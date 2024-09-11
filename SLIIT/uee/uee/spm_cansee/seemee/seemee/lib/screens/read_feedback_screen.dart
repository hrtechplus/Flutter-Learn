import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class ReadFeedbackScreen extends StatefulWidget {
  @override
  _ReadFeedbackScreenState createState() => _ReadFeedbackScreenState();
}

class _ReadFeedbackScreenState extends State<ReadFeedbackScreen> {
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
        ? feedbackText.substring(0, 20) + "..."
        : feedbackText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          subtitle:
                              Text(formattedDateTime), // Dynamic date and time
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
              onTap: () {
                // Start listening to the user's voice
              },
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(75), // Rounded circle
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
          ],
        ),
      ),
    );
  }
}
