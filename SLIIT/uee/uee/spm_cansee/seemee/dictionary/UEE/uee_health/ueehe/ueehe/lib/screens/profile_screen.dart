import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  // Blood types list for the dropdown
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

  String? _selectedBloodGroup; // Holds the selected blood type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.menu, size: 28, color: Colors.black54),
                    onPressed: () {},
                  ),
                  const Text(
                    "Hello, Hasindu",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Health Profile Title
              const Text(
                "Health Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "To keep you safe we get those",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration("Name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
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

                      // Phone Number and Blood Group Row
                      Row(
                        children: [
                          // Phone Number Field
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: _buildInputDecoration("Phone Number"),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Blood Group Dropdown
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: _buildInputDecoration("Blood Group"),
                              value: _selectedBloodGroup,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedBloodGroup = newValue!;
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Please select your blood group'
                                  : null,
                              items: _bloodGroups.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Allergies Field
                      TextFormField(
                        controller: _allergiesController,
                        decoration: _buildInputDecoration(
                            "Allergies (Additional Notes)"),
                        maxLines: 3,
                        validator: (value) {
                          return null; // Allergies can be optional
                        },
                      ),
                      const SizedBox(height: 40),

                      // Save Button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle form submission, e.g., save profile data
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Profile saved successfully!')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build InputDecoration for TextFormField
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black54, // Subtle grey color
        fontSize: 16, // Larger font size for better readability
        fontWeight: FontWeight.w500, // Make it slightly bold
      ),
      filled: true,
      fillColor: Colors.grey[200], // Light grey background for input fields
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 18.0,
      ),
    );
  }
}
