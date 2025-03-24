import 'package:flutter/material.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final localizations = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.table_rows),
          label: localizations.table,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: localizations.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_alarm),
          label: localizations.day,
        ),
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
