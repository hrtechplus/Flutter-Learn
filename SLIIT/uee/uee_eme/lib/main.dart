import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Profile Form',
      home: MedicalProfileForm(),
    );
  }
}

class MedicalProfileForm extends StatefulWidget {
  @override
  _MedicalProfileFormState createState() => _MedicalProfileFormState();
}

class _MedicalProfileFormState extends State<MedicalProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture user input
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final allergiesController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final additionalNotesController = TextEditingController();

  // Blood type selection
  String? _selectedBloodType;

  @override
  void dispose() {
    // Clean up controllers when the form is disposed
    nameController.dispose();
    ageController.dispose();
    allergiesController.dispose();
    emergencyContactController.dispose();
    additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Medical Profile Form'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.08),
                  Image.network(
                    "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.08),
                  Text(
                    "Medical Profile",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Full name',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Age
                        TextFormField(
                          controller: ageController,
                          decoration: const InputDecoration(
                            hintText: 'Age',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            } else if (int.tryParse(value) == null ||
                                int.parse(value) <= 0) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Blood Type Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedBloodType,
                          decoration: const InputDecoration(
                            hintText: 'Blood Type',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          items: [
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'AB+',
                            'AB-',
                            'O+',
                            'O-'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBloodType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your blood type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Allergies
                        TextFormField(
                          controller: allergiesController,
                          decoration: const InputDecoration(
                            hintText: 'Allergies',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter any allergies';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Emergency Contact
                        TextFormField(
                          controller: emergencyContactController,
                          decoration: const InputDecoration(
                            hintText: 'Emergency Contact Number',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an emergency contact number';
                            } else if (!RegExp(r'^\+?0[0-9]{9,13}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Additional Notes
                        TextFormField(
                          controller: additionalNotesController,
                          decoration: const InputDecoration(
                            hintText: 'Additional Notes',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            return null; // Optional field, no validation needed
                          },
                        ),
                        const SizedBox(height: 32.0),

                        // Save Profile Button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Profile saved successfully!')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF00BF6D),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Save Profile"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
