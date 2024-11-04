import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "https://localhost:443"; // HTTPS URL for backend

  // Example function to fetch data from the Node.js backend
  Future<List<dynamic>> fetchAmbulances() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/ambulances'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Convert the response body to JSON
    } else {
      throw Exception('Failed to load ambulances');
    }
  }

  // You can add more methods here to handle POST, PUT, DELETE requests as needed.
}
