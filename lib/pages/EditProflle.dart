import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ProfileLogic.dart';
import 'package:flutter_application_1/api_services/ApiService.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileController controller;

  EditProfilePage({required this.controller});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthNumberController; // New controller

  String? _selectedDoctor;
  String? _selectedConsultant;
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _consultants = [];

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _firstNameController =
        TextEditingController(text: widget.controller.firstName);
    _lastNameController =
        TextEditingController(text: widget.controller.lastName);
    _phoneController = TextEditingController(text: widget.controller.phone);
    _emailController = TextEditingController(text: widget.controller.email);
    _birthNumberController = TextEditingController(
        text: widget.controller.birthNumber); // Pre-fill birth number

    _selectedDoctor = widget.controller.doctorName;
    _selectedConsultant = widget.controller.consultantName;

    try {
      _doctors = await _apiService.fetchDoctors();
      _consultants = await _apiService.fetchConsultants();
      setState(() {});
    } catch (e) {
      print("Error fetching doctor/consultant list: $e");
    }
  }

  void _updateProfile() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text; // New field
    String birthNumber = _birthNumberController.text; // New field

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        birthNumber.isEmpty) {
      // Validate new fields too
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    String? token = await _apiService.getToken();
    if (token == null) return;

    try {
      await _apiService.updateUserProfile(
        token: token,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email, // Include email
        birthNumber: birthNumber, // Include birth number
        doctor: _selectedDoctor!,
        consultant: _selectedConsultant!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully!")),
      );

      Navigator.pop(context, true); // Return true to refresh ProfilePage
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Added to handle overflow
          child: Column(
            children: [
              _buildTextField("First Name", _firstNameController),
              _buildTextField("Last Name", _lastNameController),
              _buildTextField("Phone", _phoneController),
              _buildTextField("Email", _emailController), // Now editable
              _buildTextField(
                  "Birth Number", _birthNumberController), // New field
              _buildDropdownField("Select Doctor", _selectedDoctor, _doctors,
                  (value) => setState(() => _selectedDoctor = value)),
              _buildDropdownField(
                  "Select Consultant",
                  _selectedConsultant,
                  _consultants,
                  (value) => setState(() => _selectedConsultant = value)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child:
                    const Text("Save Changes", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<Map<String, dynamic>> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['name'],
            child: Text(item['name']),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
