import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class ProfileController {
  final String firstName = "John";
  final String lastName = "Doe";
  final String email = "john.doe@example.com";
  final String phone = "+1 234 567 890";
  final String birthNumber = "123456/7890";
  final int age = 30;
  final String consultantName = "Dr. Smith";
  final String doctorName = "Dr. Johnson";
  final String profileImageUrl = "https://via.placeholder.com/150";

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Log out the user
                mainScreenKey.currentState?.toggleAuthentication(false);

                // Close the Profile Page and navigate to login
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the Profile Page
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
