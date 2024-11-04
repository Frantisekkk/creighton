// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

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
}
