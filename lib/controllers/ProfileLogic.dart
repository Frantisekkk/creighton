import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/state/AppState.dart';

class ProfileController {
  late String firstName;
  late String lastName;
  late String email;
  late String phone;
  late String consultantName;
  late String doctorName;
  late String profileImageUrl; // if you want to support a profile image

  ProfileController(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final userProfile = appState.userProfile ?? {};

    firstName = userProfile['first_name'] ?? "N/A";
    lastName = userProfile['last_name'] ?? "N/A";
    email = userProfile['email'] ?? "N/A";
    phone = userProfile['phone'] ?? "N/A";
    consultantName = userProfile['consultant_name'] ?? "N/A";
    doctorName = userProfile['doctor_name'] ?? "N/A";
    profileImageUrl =
        userProfile['profile_image'] ?? "https://via.placeholder.com/150";
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                appState.logout();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the Profile Page
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
