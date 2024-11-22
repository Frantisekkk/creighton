import 'package:flutter/material.dart';
import '../widgets/greeting.dart';
import '../widgets/ColorDisplayContainer.dart';
import '../widgets/week.dart';
import '../widgets/graph.dart';


class HomePage extends StatelessWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenHeightWithoutBottomNav = screenHeight - kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Greeting(userName: userName, height: screenHeightWithoutBottomNav / 2 * 0.4),
            ColorDisplayContainer(height: screenHeightWithoutBottomNav / 2 * 0.75),
            WeeklyStickersRow(height: screenHeightWithoutBottomNav / 8),
            CircularProgressIndicatorSection(height: screenHeightWithoutBottomNav / 2 * 0.5),
          ],
        ),
      ),
    );
  }
}
