import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FeedbackReportScreen extends StatelessWidget {
  final CollectionReference feedbacks =
      FirebaseFirestore.instance.collection('feedbacks');

  // Method to format date and time
  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – kk:mm').format(date);
  }

  // Method to generate the PDF
  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    // Fetch feedback data from Firestore
    QuerySnapshot snapshot =
        await feedbacks.orderBy('timestamp', descending: true).get();
    List<pw.Widget> feedbackTableRows = [];

    // Add a header with the total number of feedbacks
    feedbackTableRows.add(
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Text(
          'Feedback Report - Total Feedbacks: ${snapshot.docs.length}',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
      ),
    );

    // Create table headers
    feedbackTableRows.add(
      // ignore: deprecated_member_use
      pw.Table.fromTextArray(
        headers: ['Feedback Text', 'Date & Time'],
        columnWidths: {
          0: const pw.FlexColumnWidth(4),
          1: const pw.FlexColumnWidth(2),
        },
        border: pw.TableBorder.all(),
        cellStyle: const pw.TextStyle(fontSize: 12),
        headerStyle: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        data: snapshot.docs.map((document) {
          String feedbackText = document['feedback'] ?? 'No feedback provided';
          Timestamp timestamp = document['timestamp'] ?? Timestamp.now();
          String formattedDate = _formatTimestamp(timestamp);
          return [feedbackText, formattedDate];
        }).toList(),
      ),
    );

    // Add all feedbacks to the PDF document in table format
    pdf.addPage(
      pw.MultiPage(
        build: (context) => feedbackTableRows,
      ),
    );

    // Save or print the PDF
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: feedbacks
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No feedback available."));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      String feedbackText =
                          document['feedback'] ?? 'No feedback provided';
                      Timestamp timestamp =
                          document['timestamp'] ?? Timestamp.now();
                      String formattedDateTime = _formatTimestamp(timestamp);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            feedbackText,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Date: $formattedDateTime',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          leading: const Icon(
                            Icons.feedback,
                            color: Colors.blueAccent,
                            size: 40,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _generatePdf(context),
              icon: const Icon(
                Icons.download,
                color: Colors.white, // White icon color
              ),
              label: const Text(
                "Download Report as PDF",
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 18, // Font size
                  fontWeight: FontWeight.bold, // Bold font
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blueAccent, // Background color of the button
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 40), // Padding inside the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
