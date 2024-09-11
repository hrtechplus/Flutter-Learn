import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Read Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display feedback list
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
                      String feedbackText = document['feedback'];
                      Timestamp timestamp =
                          document['timestamp'] ?? Timestamp.now();
                      DateTime date = timestamp.toDate();

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text("Feedback title"),
                          subtitle: Text("${date.toLocal()}"
                              .split(' ')[0]), // Show only the date part
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
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Listening...",
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
