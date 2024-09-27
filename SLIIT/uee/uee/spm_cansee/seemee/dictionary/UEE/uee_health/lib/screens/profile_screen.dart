import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  Future<void> _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('profiles').add({
        'name': _nameController.text,
        'age': _ageController.text,
        'phone': _phoneController.text,
        'bloodGroup': _bloodGroupController.text,
        'allergies': _allergiesController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text("Health Profile", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              buildTextFormField("Name", "Enter your name", _nameController),
              const SizedBox(height: 20),
              buildTextFormField(
                "Age",
                "Enter your age",
                _ageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              buildTextFormField(
                "Phone Number",
                "Enter your phone number",
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              buildTextFormField("Blood Group", "Enter your blood group",
                  _bloodGroupController),
              const SizedBox(height: 20),
              buildTextFormField(
                  "Allergies", "Enter your allergies", _allergiesController),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _saveProfile(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Save", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
