import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ProfileLogic.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(context);
    _loadProfileData();
  }

  void _loadProfileData() async {
    await _controller.loadProfileData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // backgroundImage: NetworkImage(_controller.profileImageUrl),
                    backgroundColor: Colors.blueGrey,
                  ),
                  const SizedBox(height: 20),
                  Text("${_controller.firstName} ${_controller.lastName}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(_controller.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 20),
                  _buildProfileItem("Phone", _controller.phone),
                  _buildProfileItem("Birth Number", _controller.birthNumber),
                  _buildProfileItem(
                      "Consultant Name", _controller.consultantName),
                  _buildProfileItem("Doctor Name", _controller.doctorName),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/edit-profile'),
                    child: const Text("Edit Profile",
                        style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _controller.showLogoutConfirmationDialog(),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Logout",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
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
