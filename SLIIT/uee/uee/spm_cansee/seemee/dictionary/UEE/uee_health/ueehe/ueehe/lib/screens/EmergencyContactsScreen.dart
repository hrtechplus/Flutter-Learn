import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For storing contacts locally

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  _EmergencyContactsScreenState createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<Contact> _contacts = []; // List of contacts selected from the phone
  List<Map<String, String>> _emergencyContacts =
      []; // Stored contacts with nicknames

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts(); // Load saved emergency contacts on startup
  }

  // Load emergency contacts from SharedPreferences
  Future<void> _loadEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedContacts = prefs.getStringList('emergencyContacts') ?? [];

    setState(() {
      _emergencyContacts = savedContacts
          .map((contactJson) async {
            Map<String, String> contact = Map<String, String>.from(
                Map<String, dynamic>.from(await _decodeJson(contactJson)));
            return contact;
          })
          .cast<Map<String, String>>()
          .toList();
    });
  }

  // Save emergency contacts to SharedPreferences
  Future<void> _saveEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactJsonList = _emergencyContacts
        .map((contact) async => await _encodeJson(contact))
        .cast<String>()
        .toList();
    await prefs.setStringList('emergencyContacts', contactJsonList);
  }

  Future<void> _requestContactsPermission() async {
    PermissionStatus permission = await Permission.contacts.request();
    if (permission.isGranted) {
      _selectContactFromPhoneBook();
    } else {
      // Handle permission denied scenario
      // Show success message
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,

        content: AwesomeSnackbarContent(
          title: 'Permission denied',
          message: 'Please allow permission to add emergency contacts.',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  // Select a contact from the phone book
  Future<void> _selectContactFromPhoneBook() async {
    try {
      Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null) {
        _addContactToEmergencyList(contact);
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error selecting contact: $e")));
    }
  }

  // Add contact to emergency list and manage nickname
  Future<void> _addContactToEmergencyList(Contact contact) async {
    TextEditingController _nicknameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Contact Nickname"),
        content: TextField(
          controller: _nicknameController,
          decoration: const InputDecoration(
            labelText: "Nickname",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog without saving
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _emergencyContacts.add({
                  'name': contact.displayName ?? "Unnamed",
                  'phone': contact.phones!.first.value ?? "No Number",
                  'nickname': _nicknameController.text.isNotEmpty
                      ? _nicknameController.text
                      : contact.displayName ?? "Unnamed",
                });
                _saveEmergencyContacts(); // Save the updated list
              });
              Navigator.pop(context); // Close the dialog after saving
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Edit the nickname of a selected emergency contact
  Future<void> _editContactNickname(int index) async {
    TextEditingController _nicknameController = TextEditingController();
    _nicknameController.text = _emergencyContacts[index]['nickname']!;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Nickname"),
        content: TextField(
          controller: _nicknameController,
          decoration: const InputDecoration(
            labelText: "Nickname",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog without saving
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _emergencyContacts[index]['nickname'] =
                    _nicknameController.text.isNotEmpty
                        ? _nicknameController.text
                        : _emergencyContacts[index]['name']!;
                _saveEmergencyContacts(); // Save the updated list
              });
              Navigator.pop(context); // Close the dialog after saving
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Delete a contact from the emergency list
  Future<void> _deleteContact(int index) async {
    setState(() {
      _emergencyContacts.removeAt(index);
      _saveEmergencyContacts(); // Save the updated list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _requestContactsPermission, // Select a new contact
          ),
        ],
      ),
      body: _emergencyContacts.isEmpty
          ? const Center(
              child: Text("No emergency contacts added yet"),
            )
          : ListView.builder(
              itemCount: _emergencyContacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_emergencyContacts[index]['name']!),
                  subtitle: Text(
                      "Nickname: ${_emergencyContacts[index]['nickname']}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editContactNickname(index);
                      } else if (value == 'delete') {
                        _deleteContact(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Nickname'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Contact'),
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Text(
                      _emergencyContacts[index]['name']![0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // JSON encoding/decoding helpers
  Future<String> _encodeJson(Map<String, String> contact) async {
    return contact.toString();
  }

  Future<Map<String, dynamic>> _decodeJson(String contactJson) async {
    return {
      'name': contactJson.split(',')[0],
      'phone': contactJson.split(',')[1],
      'nickname': contactJson.split(',')[2]
    };
  }
}
