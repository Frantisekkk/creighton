import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example raw data
    final String firstName = "John";
    final String lastName = "Doe";
    final String email = "john.doe@example.com";
    final String phone = "+1 234 567 890";
    final String birthNumber = "123456/7890";
    final int age = 30;
    final String consultantName = "Dr. Smith";
    final String doctorName = "Dr. Johnson";
    final String profileImageUrl = "https://via.placeholder.com/150";

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
              ),
              SizedBox(height: 20),
              Text(
                "$firstName $lastName",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(email, style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 20),
              _buildProfileItem("Phone", phone),
              _buildProfileItem("Birth Number", birthNumber),
              _buildProfileItem("Age", age.toString()),
              _buildProfileItem("Consultant Name", consultantName),
              _buildProfileItem("Doctor Name", doctorName),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Future API call for editing profile
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
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

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
