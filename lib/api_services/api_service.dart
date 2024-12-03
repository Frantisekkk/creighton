import 'dart:convert';
// import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = 'http://172.18.211.73:3000/api';

  // Fetch sticker (color) by date
  Future<List<String>> fetchStickerByDate(String date) async {
    final url = Uri.parse('$baseUrl/day?date=$date');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item['color'] as String).toList();
      } else {
        throw Exception('Failed to fetch sticker data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  // Fetch day data by date (for day page)
  Future<Map<String, dynamic>> fetchDayData(String date) async {
    final url = Uri.parse('$baseUrl/day?date=$date');
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
      print("Fetching data for day offset: $i");
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print("Formatted date: $formattedDate");

      // Fetch sticker for the specific date
      final url = Uri.parse('$baseUrl/day?date=$formattedDate');
      print("Requesting URL: $url");

      try {
        final response = await http.get(url);
        print("Response status: ${response.statusCode}");

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          print("Received data: $data");

          if (data.isNotEmpty) {
            stickerData.add({
              'date': formattedDate,
              'color': data[0]['color'] ?? 'unknown', // Fallback for null values
            });
          } else {
            stickerData.add({
              'date': formattedDate,
              'color': 'no data',
            });
          }
        } else {
          print("Error fetching data for $formattedDate: ${response.reasonPhrase}");
        }
      } catch (e) {
        print("HTTP request failed for $formattedDate: $e");
      }
    }
    print("Final sticker data: $stickerData");
    return stickerData;
  } catch (e) {
    print("Error in fetchStickersForLastWeek: $e");
    throw Exception('Error fetching stickers: $e');
  }
}
// Update bleeding
  Future<void> updateBleeding(String date, String bleeding) async {
    final url = Uri.parse('$baseUrl/day/bleeding');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'date': date, 'bleeding': bleeding}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update bleeding');
      }
    } catch (error) {
      throw Exception('Error updating bleeding: $error');
    }
  }

  // Update mucus
  Future<void> updateMucus(String date, String mucus) async {
    final url = Uri.parse('$baseUrl/day/mucus');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'date': date, 'mucus': mucus}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update mucus');
      }
    } catch (error) {
      throw Exception('Error updating mucus: $error');
    }
  }

  // Update fertility
  Future<void> updateFertility(String date, String fertility) async {
    final url = Uri.parse('$baseUrl/day/fertility');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'date': date, 'fertility': fertility}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update fertility');
      }
    } catch (error) {
      throw Exception('Error updating fertility: $error');
    }
  }






}


