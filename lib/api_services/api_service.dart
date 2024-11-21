import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = 'http://172.18.211.73:3000/api';

  // Fetch sticker (color) by date
  Future<List<String>> fetchStickerByDate(String date) async {
    final url = Uri.parse('$baseUrl/day?date=$date');
    print("url is: $baseUrl/day?date=$date");
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






}


