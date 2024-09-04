import 'package:flutter/material.dart';
import '../model/medical_details.dart';
import '../services/local_storage_service.dart';
import '../widgets/form_input_field.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  MedicalDetails _medicalDetails = MedicalDetails(
      fullName: '',
      phone: '',
      bloodType: '',
      allergies: '',
      emergencyContact: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medical Details')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            FormInputField(
              label: 'Full Name',
              onSaved: (value) => _medicalDetails.fullName = value ?? '',
            ),
            FormInputField(
              label: 'Phone Number',
              onSaved: (value) => _medicalDetails.phone = value ?? '',
            ),
            // Add other fields similarly
            ElevatedButton(
              onPressed: _saveForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      LocalStorageService.saveMedicalDetails(
          'medical_details', _medicalDetails.toMap());
    }
  }
}
