import 'package:flutter/material.dart';
import '../api_services/api_service.dart';

class SignUpLogic extends ChangeNotifier {
  final ApiService apiService = ApiService();

  /// Registers a new user. Returns `true` on success, otherwise `false`.
  Future<bool> registerUser(String firstName, String lastName, String email,
      String password, BuildContext context) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return false;
    }

    try {
      await apiService.registerUser(firstName, lastName, email, password);
      return true; // Registration successful
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
      return false;
    }
  }
}
