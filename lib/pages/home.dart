import 'package:flutter/material.dart';
import '../widgets/home_page_components/greeting.dart';
import '../widgets/home_page_components/ColorDisplayContainer.dart';
import '../widgets/home_page_components/week.dart';
import '../widgets/home_page_components/graph.dart';
import '../pages/login_page.dart'; // Import the LoginPage

class HomePage extends StatelessWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenHeightWithoutBottomNav =
        screenHeight - kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Greeting(
              userName: userName,
              height: screenHeightWithoutBottomNav / 2 * 0.4,
            ),
            ColorDisplayContainer(
              height: screenHeightWithoutBottomNav / 2 * 0.75,
            ),
            WeeklyStickersRow(height: screenHeightWithoutBottomNav / 8),
            CircularProgressIndicatorSection(
              height: screenHeightWithoutBottomNav / 2 * 0.5,
            ),
            SizedBox(height: 20), // Add spacing before the button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(onLoginSuccess: () {
                            // Handle successful login
                          })),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Go to Login',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20), // Add spacing after the button
          ],
        ),
      ),
    );
  }
}
