import 'package:flutter/material.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.table_rows), label: 'Table'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.access_alarm), label: 'Day'),
      ],
      currentIndex: appState.selectedIndex,
      onTap: (index) => appState.setPage(index),
      backgroundColor: Colors.grey.shade400,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    );
  }
}
