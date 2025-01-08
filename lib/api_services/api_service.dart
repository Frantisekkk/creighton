import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = 'http://192.168.0.75:3000/api';

  // Fetch day data by date (for day page)
  Future<Map<String, dynamic>> fetchDayData(String date) async {
    final url = Uri.parse('$baseUrl/day?date=$date');
    // print(url);
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

  // Update temperature in the database
  Future<void> updateTemperature(String date, double temperature) async {
    final url = Uri.parse('$baseUrl/day/update');
    print("this is url for posting temperature and it is called:" + '$url');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'date': date,
          'updates': {'temperature': temperature},
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update temperature');
      }
    } catch (error) {
      throw Exception('Error updating temperature: $error');
    }
  }
}
