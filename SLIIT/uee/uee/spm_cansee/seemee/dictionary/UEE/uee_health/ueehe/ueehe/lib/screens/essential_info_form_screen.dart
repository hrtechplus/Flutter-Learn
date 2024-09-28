import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EssentialInfoFormScreen extends StatefulWidget {
  @override
  _EssentialInfoFormScreenState createState() =>
      _EssentialInfoFormScreenState();
}

class _EssentialInfoFormScreenState extends State<EssentialInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  String? _selectedBloodGroup;
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Essential Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Full Name Field
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration("Full Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age Field
              TextFormField(
                controller: _ageController,
                decoration: _buildInputDecoration("Age"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Blood Group Dropdown
              DropdownButtonFormField<String>(
                decoration: _buildInputDecoration("Blood Group"),
                value: _selectedBloodGroup,
                items: _bloodGroups.map((String bloodGroup) {
                  return DropdownMenuItem<String>(
                    value: bloodGroup,
                    child: Text(bloodGroup),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBloodGroup = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your blood group';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Emergency Contact Field
              TextFormField(
                controller: _emergencyContactController,
                decoration: _buildInputDecoration("Emergency Contact"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an emergency contact';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveUserInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  // Save user info to SharedPreferences
  Future<void> _saveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _nameController.text);
    await prefs.setString('age', _ageController.text);
    await prefs.setString('bloodGroup', _selectedBloodGroup ?? '');
    await prefs.setString('emergencyContact', _emergencyContactController.text);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile created successfully!')),
    );

    // Navigate to Home Screen (SOS screen)
    Navigator.pushReplacementNamed(context, '/home');
  }
}
