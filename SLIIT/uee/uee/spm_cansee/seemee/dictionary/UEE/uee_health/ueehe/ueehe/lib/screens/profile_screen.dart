import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _name = "Hasindu Rangika";
  String? _birthdate = "Tue, May 29 2001 (23 Years)";
  String? _bloodType = "B+";
  String? _height = "165cm";
  String? _weight = "55Kg";
  String? _address = "Minuwangoda, Sri Lanka";
  String? _phoneNumber = "071 0840 270";
  String? _gender = "Male";
  String? _allergies = "None";

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load the saved profile data from SharedPreferences
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? _name;
      _birthdate = prefs.getString('birthdate') ?? _birthdate;
      _bloodType = prefs.getString('blood_group') ?? _bloodType;
      _height = prefs.getString('height') ?? _height;
      _weight = prefs.getString('weight') ?? _weight;
      _address = prefs.getString('address') ?? _address;
      _phoneNumber = prefs.getString('phone') ?? _phoneNumber;
      _gender = prefs.getString('gender') ?? _gender;
      _allergies = prefs.getString('allergies') ?? _allergies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              // Health Profile Section
              const Text(
                "Health Profile",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 1),
              const Text(
                "To keep you safe we get those",
                style: TextStyle(
                    color: Color.fromARGB(95, 0, 0, 0),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 20),
              // Profile Image
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red[300],
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name and Birthdate
              Center(
                child: Column(
                  children: [
                    Text(
                      _name ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Birthday: ' + (_birthdate ?? ''),
                      semanticsLabel: _birthdate ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Blood Type, Height, Weight in a Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHealthData("Blood T", _bloodType ?? ''),
                  _buildHealthData("Height", (_height ?? '') + 'cm'),
                  _buildHealthData("Weight", (_weight ?? '') + 'Kg'),
                ],
              ),
              const SizedBox(height: 30),

              // Extra Information Section
              const Text(
                "Extra Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Address, Phone, Gender
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildExtraInfo(Icons.location_on, _address ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildExtraInfo(Icons.phone, _phoneNumber ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildExtraInfo(Icons.person, _gender ?? ''),
              ),
              const SizedBox(height: 30),

              // General Information Section (Allergies)
              const Text(
                "General Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _allergies ?? 'Allergies (Additional Notes)',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Floating Edit Button
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(
              context, '/editProfile'); // Navigate to edit screen
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  // Helper Widget for Health Profile data (Blood Type, Height, Weight)
  Widget _buildHealthData(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Helper Widget for Extra Information (Address, Phone, Gender)
  Widget _buildExtraInfo(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              info,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
