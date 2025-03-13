import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://192.168.0.75:3000/api';

  // ----------------------------------------------------------------------
  // Merged method for fetching a day's color.
  // Returns a Color based on the 'sticker' field from the API.
  // Now requires a JWT token to specify which user.
  // ----------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchDayData(String date,
      {required String token}) async {
    print("Fetching day data with token: $token");

    final url = Uri.parse('$baseUrl/day?date=$date');
    print(url);

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          // Handling empty response case
          return {
            'stickerColor': Colors.grey,
            'bleeding': 'No data',
            'mucus': 'No data',
            'fertility': 'No data',
            'ab': false,
          };
        }

        final data = json.decode(response.body);

        // If data is empty, return default values
        if (data == null || data.isEmpty) {
          return {
            'stickerColor': Colors.grey,
            'bleeding': 'No data',
            'mucus': 'No data',
            'fertility': 'No data',
            'ab': false,
          };
        }

        final String? stickerName = data['sticker'] as String?;
        data['stickerColor'] = (stickerName != null && stickerName.isNotEmpty)
            ? getColor(stickerName)
            : Colors.grey;

        return data;
      } else if (response.statusCode == 404) {
        // Handle "not found" case by returning default values
        print('No data found for the given date.');
        return {
          'stickerColor': Colors.grey,
          'bleeding': 'No data',
          'mucus': 'No data',
          'fertility': 'No data',
          'ab': false,
        };
      } else {
        return {
          'error':
              'Failed to fetch day data. Status code: ${response.statusCode}',
        };
      }
    } catch (error) {
      // Instead of throwing an error, return an error message in the response
      return {
        'error': 'Error fetching day data: $error',
      };
    }
  }

  // ----------------------------------------------------------------------
  // Merged method for fetching colors for the last week.
  // Returns a List<Color> by retrieving and mapping each day’s 'sticker' field.
  // Now requires a JWT token to specify which user.
  // ----------------------------------------------------------------------
  Future<List<Color>> fetchStickersForLastWeek({required String token}) async {
    print("Fetching day data with token: $token");

    try {
      List<Color> colors = [];
      for (int i = 6; i >= 0; i--) {
        DateTime date = DateTime.now().subtract(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        final url = Uri.parse('$baseUrl/day?date=$formattedDate');
        try {
          final response = await http.get(
            url,
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            },
          );
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
  Future<Map<String, dynamic>> startNewCycle({required String token}) async {
    final url = Uri.parse('$baseUrl/cycle/new');
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
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
  Future<Map<String, dynamic>> undoCycle({required String token}) async {
    final url = Uri.parse('$baseUrl/cycle/undo');
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
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
  Future<Map<String, dynamic>> deleteLastCycle({required String token}) async {
    final url = Uri.parse('$baseUrl/cycle/delete_last');
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete the last cycle');
      }
    } catch (error) {
      throw Exception('Error deleting last cycle: $error');
    }
  }

  // Fetching cycle data
  Future<List<List<Map<String, dynamic>>>> fetchCycleData(
      {required String token}) async {
    print("Fetching day data with token: $token");

    final url = Uri.parse('$baseUrl/cycles');
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );
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

  Future<void> updateDayData(String date, Map<String, dynamic> updates,
      {required String token}) async {
    final url = Uri.parse('$baseUrl/day/update');
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({'date': date, 'updates': updates}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update day data');
      }
    } catch (error) {
      throw Exception('Error updating day data: $error');
    }
  }

  Future<void> updateBleeding(String date, String bleeding,
      {required String token}) async {
    final url = Uri.parse('$baseUrl/day/bleeding');
    await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: json.encode({'date': date, 'bleeding': bleeding}),
    );
  }

  Future<void> updateMucus(String date, String mucus,
      {required String token}) async {
    final url = Uri.parse('$baseUrl/day/mucus');
    await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: json.encode({'date': date, 'mucus': mucus}),
    );
  }

  Future<void> updateFertility(String date, String fertility,
      {required String token}) async {
    final url = Uri.parse('$baseUrl/day/fertility');
    await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: json.encode({'date': date, 'fertility': fertility}),
    );
  }

  Future<void> updateTemperature(String date, double temperature,
      {required String token}) async {
    final url = Uri.parse('$baseUrl/day/temperature');
    print(
        "POSTing temperature to: $url with data {date: $date, temperature: $temperature}");
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({'date': date, 'temperature': temperature}),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception('Failed to update temperature');
      }
    } catch (error) {
      print("Error updating temperature: $error");
    }
  }

  Future<void> updateAbdominalPain(String date, bool abdominalPain,
      {required String token}) async {
    final url = Uri.parse('$baseUrl/day/abdominal_pain');
    print("updating abdominal pain: $url");
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({'date': date, 'ab': abdominalPain}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update abdominal pain');
      }
    } catch (error) {
      throw Exception('Error updating abdominal pain: $error');
    }
  }

  Future<String> updateStickerColor(String date, String colorName,
      {required String token}) async {
    final url = Uri.parse('$baseUrl/day/sticker');

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({'date': date, 'sticker': colorName}),
      );

      if (response.statusCode == 200) {
        return 'Sticker color updated successfully';
      } else {
        return 'Failed to update sticker color: ${response.body}';
      }
    } catch (error) {
      return 'Error updating sticker color: $error';
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
        final data = json.decode(response.body);
        final token = data['token']; // Get JWT token
        if (token != null) {
          await saveToken(token); // Store token locally
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // Save token locally (Use shared_preferences)
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Retrieve token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Remove JWT token on logout
  Future<void> logout() async {
    final url =
        Uri.parse('$baseUrl/logout'); // Backend logout endpoint (optional)
    final prefs = await SharedPreferences.getInstance();

    try {
      final token = await getToken();
      if (token != null) {
        await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
        );
      }
    } catch (e) {
      print("Error logging out from backend: $e");
    }

    // Clear stored JWT token
    await prefs.remove('jwt_token');

    print("User logged out successfully.");
  }

  Future<bool> registerUser(
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

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        print('Registration failed: ${response.body}');
        return false; // Registration failed
      }
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  // For fetching doctors and consultants for registration
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    final url = Uri.parse('$baseUrl/doctors');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Error loading doctors: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchConsultants() async {
    final url = Uri.parse('$baseUrl/consultants');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> fetchUserProfile({required String token}) async {
    print("profile Fetching day data with token: $token");
    final url = Uri.parse('$baseUrl/user/profile');
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }
}
