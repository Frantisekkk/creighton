import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = 'http://192.168.0.75:3000/api';

  // Fetch day data by date (for day page)
  Future<Map<String, dynamic>> fetchDayData(String date) async {
    final url = Uri.parse('$baseUrl/day?date=$date');
    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body); // Return the full day's data
      } else {
        throw Exception('Failed to fetch day data');
      }
    } catch (error) {
      throw Exception('Error fetching day data: $error');
    }
  }

  // Fetch stickers for the last 7 days from the database
  Future<List<Map<String, String>>> fetchStickersForLastWeek() async {
    try {
      List<Map<String, String>> stickerData = [];
      for (int i = 6; i >= 0; i--) {
        DateTime date = DateTime.now().subtract(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        // Fetch day data for the specific date
        final url = Uri.parse('$baseUrl/day?date=$formattedDate');

        try {
          final response = await http.get(url);
          if (response.statusCode == 200) {
            Map<String, dynamic> data = json.decode(response.body);
            stickerData.add({
              'date': formattedDate,
              'color': data['sticker'] ??
                  'unknown', // Use 'sticker' column for color
            });
          } else {
            stickerData.add({
              'date': formattedDate,
              'color': 'no data',
            });
          }
        } catch (e) {
          stickerData.add({
            'date': formattedDate,
            'color': 'error',
          });
        }
      }
      return stickerData;
    } catch (e) {
      throw Exception('Error fetching stickers for last week: $e');
    }
  }

  // Fetch all cycle data
  Future<List<List<Map<String, dynamic>>>> fetchCycleData() async {
    final url = Uri.parse('$baseUrl/cycles');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Group data by cycle_id
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

  // Update day data (generic update method)
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

  // Update Bleeding
  Future<void> updateBleeding(String date, String bleeding) async {
    final url = Uri.parse('$baseUrl/day/bleeding');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'date': date, 'bleeding': bleeding}),
    );
  }

  // Update Mucus
  Future<void> updateMucus(String date, String mucus) async {
    final url = Uri.parse('$baseUrl/day/mucus');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'date': date, 'mucus': mucus}),
    );
  }

  // Update Fertility
  Future<void> updateFertility(String date, String fertility) async {
    final url = Uri.parse('$baseUrl/day/fertility');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'date': date, 'fertility': fertility}),
    );
  }

  // Update temperature in the database
  Future<void> updateTemperature(String date, double temperature) async {
    // Correct the URL by adding "/day" before "/temperature"
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

  // Update Abdominal Pain
  Future<void> updateAbdominalPain(String date, bool abdominalPain) async {
    final url = Uri.parse('$baseUrl/day/abdominal_pain');
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

  // ---------------- LOGIN APIs ----------------------

  // 1. login api
  Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Save authentication state (e.g., JWT token if applicable)
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // 2. register api
  Future<void> registerUser(
      String firstName, String lastName, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
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
}
