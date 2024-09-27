import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary',
      home: DictionaryScreen(),
    );
  }
}

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _searchQuery = '';

  List<Map<String, String>> _definitions = [
    {'word': 'Mother', 'description': 'Mother-in-law, moon'},
    // Add more sample definitions
  ];

  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _definitions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_definitions[index]['word']!),
                  subtitle: Text(_definitions[index]['description']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () {
                          // Add volume up functionality
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {
                          // Add bookmarking functionality
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                // Add search logic here
              },
              decoration: InputDecoration(
                hintText: 'Search a word',
                suffixIcon: IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () async {
                    if (!_isListening) {
                      bool available = await _speechToText.initialize();
                      if (available) {
                        setState(() => _isListening = true);
                        _speechToText.listen(onResult: (result) {
                          setState(() {
                            _searchQuery = result.recognizedWords;
                          });
                        });
                      }
                    } else {
                      setState(() => _isListening = false);
                      _speechToText.stop();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
