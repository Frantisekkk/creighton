import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/state/AppState.dart';

class LoginLogic extends ChangeNotifier {
  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password cannot be empty')),
      );
      return false;
    }

    // Retrieve AppState from the Provider
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      // Call AppState's login method
      final bool isAuthenticated = await appState.login(email, password);
      if (!isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials')),
        );
      }
      return isAuthenticated;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
      return false;
    }
  }
}
