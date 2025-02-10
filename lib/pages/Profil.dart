import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ProfileLogic.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.fetchUserProfile(1); // Replace 1 with the actual userId
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading
          : Consumer<AppState>(
              builder: (context, appState, child) {
                final userProfile = appState.userProfile;

                if (userProfile == null) {
                  return const Center(child: Text("Failed to load profile."));
                }

                final controller = ProfileController(context);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(controller.profileImageUrl),
                        backgroundColor: Colors.blueGrey,
                      ),
                      const SizedBox(height: 20),
                      Text("${controller.firstName} ${controller.lastName}",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(controller.email,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 20),
                      _buildProfileItem("Phone", controller.phone),
                      _buildProfileItem("Birth Number", "123456/7890"),
                      _buildProfileItem("Age", "30"),
                      _buildProfileItem(
                          "Consultant Name", controller.consultantName),
                      _buildProfileItem("Doctor Name", controller.doctorName),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/edit-profile'),
                        child: const Text("Edit Profile",
                            style: TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () =>
                            controller.showLogoutConfirmationDialog(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text("Logout",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
