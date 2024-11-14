// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'day_data.dart';

class ApiService {
  final String baseUrl = 'http://172.18.211.73:3000/api/users'; // Adjust based on your setup

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
  Future<DayData> fetchDayData({required String date, required int userId}) async {
    final response = await http.get(Uri.parse('$baseUrl/day?date=$date&user_id=$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return DayData.fromJson(data);
    } else {
      throw Exception('Failed to load day data');
    }
  }
}
