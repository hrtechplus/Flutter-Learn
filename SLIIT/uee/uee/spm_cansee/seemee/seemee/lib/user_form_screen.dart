import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Use Firestore

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  void _saveUserData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save the data to Firestore
      _usersCollection.add({
        'name': _name,
        'email': _email,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data saved successfully!')),
        );
        _fetchUserData(); // Fetch data after saving
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user data: $error')),
        );
      });
    }
  }

  List<Map<String, String>> _users = [];

  void _fetchUserData() {
    _usersCollection.get().then((QuerySnapshot querySnapshot) {
      List<Map<String, String>> usersList = [];
      for (var doc in querySnapshot.docs) {
        usersList.add({
          'name': doc['name'],
          'email': doc['email'],
        });
      }
      setState(() {
        _users = usersList;
      });
    }).catchError((error) {
      print('Failed to load data: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch data when screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Formmmmmmmm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveUserData,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_users[index]['name']!),
                    subtitle: Text(_users[index]['email']!),
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
