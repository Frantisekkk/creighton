import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'pages/home.dart';
import 'pages/day.dart';
// import 'pages/table.dart';
import 'pages/table.dart';
// import 'pages/user_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      theme: ThemeData(
        // fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isAuthenticated = false; // Default authentication state

  static final List<Widget> _pages = <Widget>[
    TablePage(),
    HomePage(userName: 'Monika'),
    DayPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      // Show the LoginPage if not authenticated
      return LoginPage(
        onLoginSuccess: () {
          setState(() {
            _isAuthenticated = true; // Update authentication state
          });
        },
      );
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 5.0), // Space on left, right, and bottom
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30), // Rounded corners
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.table_rows),
                label: 'Table',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_alarm),
                label: 'Day',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor:
                Colors.grey.shade400, // Background color for the bar
            selectedItemColor: Colors.blueAccent, // Color of selected item
            unselectedItemColor: Colors.grey, // Color of unselected items
            showUnselectedLabels:
                false, // Hides labels for unselected items for a minimal look
            type: BottomNavigationBarType.fixed, // Prevents shifting animation
          ),
        ),
      ),
    );
  }
}
