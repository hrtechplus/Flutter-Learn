import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Home Screen"),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Blood Group'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Additional Note'),
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Emergency Contact Number'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement save functionality
                },
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
