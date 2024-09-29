import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String? profileImagePath;
  final String fullName;
  final String birthDate;
  final String phoneNumber;
  final String bloodType;
  final String allergies;
  final String height;
  final String weight;

  const EditProfileScreen({
    super.key,
    required this.profileImagePath,
    required this.fullName,
    required this.birthDate,
    required this.phoneNumber,
    required this.bloodType,
    required this.allergies,
    required this.height,
    required this.weight,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _selectedBloodGroup;
  File? _profileImage;

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
  void initState() {
    super.initState();
    _nameController.text = widget.fullName;
    _birthDateController.text = widget.birthDate;
    _phoneController.text = widget.phoneNumber;
    _allergiesController.text = widget.allergies;
    _heightController.text = widget.height;
    _weightController.text = widget.weight;
    _selectedBloodGroup = widget.bloodType;
    _profileImage =
        widget.profileImagePath != null ? File(widget.profileImagePath!) : null;
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Save updated profile data to SharedPreferences
  Future<void> _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('birthday', _birthDateController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('blood_group', _selectedBloodGroup ?? '');
    await prefs.setString('allergies', _allergiesController.text);
    await prefs.setString('height', _heightController.text);
    await prefs.setString('weight', _weightController.text);
    if (_profileImage != null) {
      await prefs.setString('profile_image', _profileImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text('Health Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('To keep you safe we get those',
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage, // Open gallery to pick profile image
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : null,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_nameController, 'Name'),
              const SizedBox(height: 16),
              _buildTextField(_birthDateController, 'Birthday'),
              const SizedBox(height: 16),
              _buildTextField(_phoneController, 'Phone Number'),
              const SizedBox(height: 16),
              _buildTextField(_heightController, 'Height'),
              const SizedBox(height: 16),
              _buildTextField(_weightController, 'Weight'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _buildInputDecoration('Blood Group'),
                value: _selectedBloodGroup,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBloodGroup = newValue;
                  });
                },
                items: _bloodGroups.map((String bloodGroup) {
                  return DropdownMenuItem<String>(
                    value: bloodGroup,
                    child: Text(bloodGroup),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                  _allergiesController, 'Allergies (Additional Notes)'),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveProfileData(); // Save updated profile data
                    Navigator.pop(context); // Navigate back to Profile Screen
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  TextFormField _buildTextField(
      TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: _buildInputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
