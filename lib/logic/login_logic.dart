import 'package:flutter/material.dart';
import '../api_services/api_service.dart';

class LoginLogic extends ChangeNotifier {
  final ApiService apiService = ApiService();

  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password cannot be empty')),
      );
      return false;
    }

    try {
      final bool isAuthenticated = await apiService.loginUser(email, password);
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
