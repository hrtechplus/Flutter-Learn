import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'edit_profile_screen.dart'; // Import the Edit Profile Screen

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = 'Loading...';
  String birthDate = 'Loading...';
  String bloodType = 'Loading...';
  String height = 'Loading...';
  String weight = 'Loading...';
  String address = 'Loading...';
  String phoneNumber = 'Loading...';
  String allergies = 'Loading...';
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load profile data from SharedPreferences
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('name') ?? 'N/A';
      birthDate = prefs.getString('birthday') ?? 'N/A';
      bloodType = prefs.getString('blood_group') ?? 'N/A';
      height = prefs.getString('height') ?? 'N/A';
      weight = prefs.getString('weight') ?? 'N/A';
      address = prefs.getString('address') ?? 'N/A';
      phoneNumber = prefs.getString('phone') ?? 'N/A';
      allergies = prefs.getString('allergies') ?? 'N/A';
      profileImagePath = prefs.getString('profile_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Health Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('To keep you safe we get those',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),

            // Profile picture and user info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath!))
                        : null,
                    child: profileImagePath == null
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
                        : null,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    fullName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    birthDate,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Blood Type, Height, Weight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn('Blood Type', bloodType),
                _buildInfoColumn('Height', '$height cm'),
                _buildInfoColumn('Weight', '$weight kg'),
              ],
            ),
            const SizedBox(height: 40),

            // Extra Information
            const Text(
              'Extra Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Address', address),
            const SizedBox(height: 10),
            _buildInfoRow('Phone number', phoneNumber),
            const SizedBox(height: 10),
            _buildInfoRow('Allergies', allergies),

            const SizedBox(height: 20),

            // Edit button
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  // Navigate to Edit Profile Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        profileImagePath: profileImagePath,
                        fullName: fullName,
                        birthDate: birthDate,
                        phoneNumber: phoneNumber,
                        bloodType: bloodType,
                        allergies: allergies,
                        height: height,
                        weight: weight,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for building UI elements
  Column _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Row _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Expanded(
          child: Text(value,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
