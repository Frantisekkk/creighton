import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = 'http://192.168.0.75:3000/api';

  // ----------------------------------------------------------------------
  // Merged method for fetching a day's color.
  // (This method now combines the logic of the former fetchColorByDate and fetchDayData.)
  // It returns a Color based on the 'sticker' field from the API.
  // ----------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchDayData(String date) async {
    final url = Uri.parse('$baseUrl/day?date=$date');
    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Compute the sticker color from the 'sticker' field
        final String? stickerName = data['sticker'] as String?;
        data['stickerColor'] = (stickerName != null && stickerName.isNotEmpty)
            ? getColor(stickerName)
            : Colors.grey;
        return data;
      } else {
        throw Exception('Failed to fetch day data');
      }
    } catch (error) {
      throw Exception('Error fetching day data: $error');
    }
  }

  // ----------------------------------------------------------------------
  // Merged method for fetching colors for the last week.
  // (This method now combines the logic of the former fetchColorsForLastWeek and fetchStickersForLastWeek.)
  // It returns a List<Color> by retrieving and mapping each day’s 'sticker' field.
  // ----------------------------------------------------------------------
  Future<List<Color>> fetchStickersForLastWeek() async {
    try {
      List<Color> colors = [];
      for (int i = 6; i >= 0; i--) {
        DateTime date = DateTime.now().subtract(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        final url = Uri.parse('$baseUrl/day?date=$formattedDate');
        try {
          final response = await http.get(url);
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final String? colorName = data['sticker'] as String?;
            if (colorName != null && colorName.isNotEmpty) {
              colors.add(getColor(colorName));
            } else {
              print('Error: No color found for date $formattedDate');
              colors.add(Colors.grey);
            }
          } else {
            colors.add(Colors.grey);
          }
        } catch (e) {
          colors.add(Colors.grey);
        }
      }
      return colors;
    } catch (e) {
      print('Error fetching stickers for last week: $e');
      return List.filled(7, Colors.grey);
    }
  }

  // --------------------- Other API Methods ----------------------------

  // Start a new cycle
  Future<Map<String, dynamic>> startNewCycle() async {
    final url = Uri.parse('$baseUrl/cycle/new');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to start a new cycle');
      }
    } catch (error) {
      throw Exception('Error starting new cycle: $error');
    }
  }

  // Undo the last cycle creation
  Future<Map<String, dynamic>> undoCycle() async {
    final url = Uri.parse('$baseUrl/cycle/undo');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to undo the last cycle');
      }
    } catch (error) {
      throw Exception('Error undoing cycle: $error');
    }
  }

  // Delete the last cycle
  Future<Map<String, dynamic>> deleteLastCycle() async {
    final url = Uri.parse('$baseUrl/cycle/delete_last');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete the last cycle');
      }
    } catch (error) {
      throw Exception('Error deleting last cycle: $error');
    }
  }

  //fetching cycle data
  Future<List<List<Map<String, dynamic>>>> fetchCycleData() async {
    final url = Uri.parse('$baseUrl/cycles');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        Map<int, List<Map<String, dynamic>>> groupedByCycle = {};
        for (var day in data) {
          int cycleId = day['cycle_id'];
          if (!groupedByCycle.containsKey(cycleId)) {
            groupedByCycle[cycleId] = [];
          }
          groupedByCycle[cycleId]!.add(day);
        }
        return groupedByCycle.values.toList();
      } else {
        throw Exception('Failed to fetch cycle data');
      }
    } catch (error) {
      throw Exception('Error fetching cycle data: $error');
    }
  }

  Future<void> updateDayData(String date, Map<String, dynamic> updates) async {
    final url = Uri.parse('$baseUrl/day/update');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'date': date, 'updates': updates}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update day data');
      }
    } catch (error) {
      throw Exception('Error updating day data: $error');
    }
  }

  Future<void> updateBleeding(String date, String bleeding) async {
    final url = Uri.parse('$baseUrl/day/bleeding');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'date': date, 'bleeding': bleeding}),
    );
  }

  Future<void> updateMucus(String date, String mucus) async {
    final url = Uri.parse('$baseUrl/day/mucus');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'date': date, 'mucus': mucus}),
    );
  }

  Future<void> updateFertility(String date, String fertility) async {
    final url = Uri.parse('$baseUrl/day/fertility');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'date': date, 'fertility': fertility}),
    );
  }

  Future<void> updateTemperature(String date, double temperature) async {
    final url = Uri.parse('$baseUrl/day/temperature');
    print("POSTing temperature to: $url");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'date': date, 'temperature': temperature}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update temperature');
      }
    } catch (error) {
      throw Exception('Error updating temperature: $error');
    }
  }

  Future<void> updateAbdominalPain(String date, bool abdominalPain) async {
    final url = Uri.parse('$baseUrl/day/abdominal_pain');
    print("updating abdominal pain: $url");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'date': date, 'abdominalPain': abdominalPain}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update abdominal pain');
      }
    } catch (error) {
      throw Exception('Error updating abdominal pain: $error');
    }
  }

  // ------------------------- LOGIN APIs -------------------------------

  Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // lib/api_services/ApiService.dart
  Future<void> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String birthNumber,
    int age,
    String phone,
    String doctor,
    String consultant,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    print({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'birth_number': birthNumber,
      'age': age,
      'phone': phone,
      'doctor': doctor,
      'consultant': consultant,
    });
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'birth_number': birthNumber,
          'age': age,
          'phone': phone,
          'doctor': doctor,
          'consultant': consultant,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception(
            'Failed to register user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  // for fetching doctors and consultats for picking in registartion
  // Fetch the list of doctors from the backend
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    final url = Uri.parse('$baseUrl/doctors');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Expecting a list of objects like: { "id": "doctor_id", "name": "Dr. John Smith" }
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Error loading doctors: $e');
    }
  }

// Fetch the list of consultants from the backend
  Future<List<Map<String, dynamic>>> fetchConsultants() async {
    final url = Uri.parse('$baseUrl/consultants');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Expecting a list of objects like: { "id": "consultant_id", "name": "Consultant Jane Doe" }
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load consultants');
      }
    } catch (e) {
      throw Exception('Error loading consultants: $e');
    }
  }

  // ------------------ Profile API's --------------------------

  // Fetch user profile
  Future<Map<String, dynamic>> fetchUserProfile(String email) async {
    final url = Uri.parse('$baseUrl/user/birth/$email');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);

        // Ensure the name is properly formatted
        userData['name'] =
            '${userData['first_name'] ?? "N/A"} ${userData['last_name'] ?? "N/A"}';

        return userData;
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (error) {
      throw Exception('Error fetching user profile: $error');
    }
  }
}
