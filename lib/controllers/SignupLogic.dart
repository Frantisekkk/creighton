import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_services/ApiService.dart';

class SignUpLogic extends ChangeNotifier {
  final ApiService apiService = ApiService();

  // Fields
  String selectedDoctor = '';
  String selectedConsultant = '';

  List<String> doctorList = [];
  List<String> consultantList = [];

  bool isLoadingDoctors = true;
  bool isLoadingConsultants = true;

  SignUpLogic() {
    loadDoctors();
    loadConsultants();
  }

  /// Fetch doctors from API
  Future<void> loadDoctors() async {
    try {
      final doctorsData = await apiService.fetchDoctors();
      doctorList = doctorsData.map((doc) => doc['name'] as String).toList();
      if (doctorList.isNotEmpty) {
        selectedDoctor = doctorList.first;
      }
    } catch (e) {
      print("Error loading doctors: $e");
    } finally {
      isLoadingDoctors = false;
      notifyListeners();
    }
  }

  /// Fetch consultants from API
  Future<void> loadConsultants() async {
    try {
      final consultantsData = await apiService.fetchConsultants();
      consultantList =
          consultantsData.map((con) => con['name'] as String).toList();
      if (consultantList.isNotEmpty) {
        selectedConsultant = consultantList.first;
      }
    } catch (e) {
      print("Error loading consultants: $e");
    } finally {
      isLoadingConsultants = false;
      notifyListeners();
    }
  }

  /// Sets selected doctor
  void setDoctor(String doctor) {
    selectedDoctor = doctor;
    notifyListeners();
  }

  /// Sets selected consultant
  void setConsultant(String consultant) {
    selectedConsultant = consultant;
    notifyListeners();
  }

  /// Registers a new user
  Future<bool> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String birthNumber,
    String ageStr,
    String phone,
    BuildContext context,
  ) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        birthNumber.isEmpty ||
        ageStr.isEmpty ||
        phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return false;
    }

    // Try to parse age
    int? age = int.tryParse(ageStr);
    if (age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid age.')),
      );
      return false;
    }

    try {
      await apiService.registerUser(
        firstName,
        lastName,
        email,
        password,
        birthNumber,
        age,
        phone,
        selectedDoctor,
        selectedConsultant,
      );
      return true; // Registration successful
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
      return false;
    }
  }
}
