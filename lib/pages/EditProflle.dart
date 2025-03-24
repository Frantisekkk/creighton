import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ProfileLogic.dart';
import 'package:flutter_application_1/api_services/ApiService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late TextEditingController _birthNumberController;

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
    _birthNumberController =
        TextEditingController(text: widget.controller.birthNumber);

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
    final localizations = AppLocalizations.of(context)!;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String birthNumber = _birthNumberController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        birthNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.fill_all_fields)),
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
        email: email,
        birthNumber: birthNumber,
        doctor: _selectedDoctor!,
        consultant: _selectedConsultant!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.profile_update_success)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.edit_profile_page_title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(localizations.first_name, _firstNameController),
              _buildTextField(localizations.last_name, _lastNameController),
              _buildTextField(localizations.phone, _phoneController),
              _buildTextField(localizations.email, _emailController),
              _buildTextField(
                  localizations.birth_number, _birthNumberController),
              _buildDropdownField(
                localizations.select_doctor,
                _selectedDoctor,
                _doctors,
                (value) => setState(() => _selectedDoctor = value),
              ),
              _buildDropdownField(
                localizations.select_consultant,
                _selectedConsultant,
                _consultants,
                (value) => setState(() => _selectedConsultant = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text(
                  localizations.save_changes,
                  style: const TextStyle(fontSize: 18),
                ),
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
