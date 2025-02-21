import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigation/BottomNavigation.dart';
import 'package:flutter_application_1/pages/Day.dart';
import 'package:flutter_application_1/pages/Login.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/table.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:provider/provider.dart';

// handles navigation in bottom navigation bar
class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // If the user is not authenticated, show Login Page
    if (!appState.isAuthenticated) {
      return LoginPage(onLoginSuccess: () {});
    }

    // Otherwise, show the main app layout with navigation
    return MainApp();
  }
}

// Manages Navigation Between Home, Table, and Day Pages
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final List<Widget> _pages = [
      TablePage(),
      HomePage(userName: 'Monika'),
      DayPage(
        key: ValueKey(appState.selectedDate),
        selectedDate: appState.selectedDate,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: appState.selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
