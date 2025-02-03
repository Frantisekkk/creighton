import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'pages/home.dart';
import 'pages/day.dart';
import 'pages/table.dart';

// GlobalKey to access the MainScreenState
final GlobalKey<_MainScreenState> mainScreenKey = GlobalKey<_MainScreenState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: mainScreenKey);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now(); // Track selected date
  bool _isAuthenticated = true; // Default authentication state
  final PageController _pageController = PageController();

  // Method to switch tabs while optionally updating selected date for DayPage
  void onItemTapped(int index, {DateTime? date}) {
    if (index == 2 && date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to toggle authentication state
  void toggleAuthentication(bool isAuthenticated) {
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return LoginPage(
        onLoginSuccess: () {
          toggleAuthentication(true);
        },
      );
    }

    List<Widget> _pages = [
      TablePage(),
      HomePage(userName: 'Monika'),
      DayPage(selectedDate: _selectedDate), // Update DayPage dynamically
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: _onPageChanged,
        physics:
            const ClampingScrollPhysics(), // Disables overscroll bounce for a smoother experience
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
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
            onTap: (index) => onItemTapped(index), // Default tap behavior
            backgroundColor: Colors.grey.shade400,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
