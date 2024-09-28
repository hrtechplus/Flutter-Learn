import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _ageController.text = prefs.getString('age') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _bloodGroupController.text = prefs.getString('blood_group') ?? '';
      _allergiesController.text = prefs.getString('allergies') ?? '';
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('age', _ageController.text);
      await prefs.setString('phone', _phoneController.text);
      await prefs.setString('blood_group', _bloodGroupController.text);
      await prefs.setString('allergies', _allergiesController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        size: 28, color: Colors.redAccent),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextFormField(
                          "Name", "Enter your name", _nameController),
                      const SizedBox(height: 16),
                      buildTextFormField(
                          "Age", "Enter your age", _ageController,
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: buildTextFormField(
                              "Phone Number",
                              "Phone Number",
                              _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildTextFormField("Blood Group",
                                "Blood Group", _bloodGroupController),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      buildTextFormField("Allergies", "Enter your allergies",
                          _allergiesController),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget buildTextFormField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.0),
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
