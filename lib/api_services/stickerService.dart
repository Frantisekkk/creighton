import 'package:flutter/material.dart';
import 'api_service.dart';

class StickerService {
  final ApiService _apiService = ApiService();

  Future<Color> fetchColorByDate(String date) async {
    try {
      final List<String> colors = await _apiService.fetchStickerByDate(date);
      if (colors.isNotEmpty) {
        return _getColor(colors[0]);
      } else {
        print('Error: No colors found for date $date');
        return Colors.grey; // Default to gray if no colors are found
      }
    } catch (e) {
      print('Error fetching color for date $date: $e');
      return Colors.grey; // Default to gray if an error occurs
    }
  }

  Future<List<Color>> fetchColorsForLastWeek() async {
    try {
      final List<Map<String, String>> stickerData =
          await _apiService.fetchStickersForLastWeek();
      return stickerData.map((data) {
        final color = data['color'];
        return color != null ? _getColor(color) : Colors.grey;
      }).toList();
    } catch (e) {
      print('Error fetching colors for the last week: $e');
      return List.filled(7, Colors.grey); // Return gray for all days in case of an error
    }
  }

  // Helper function to map color names to Flutter Color objects
  Color _getColor(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'white':
        return Colors.white;
      default:
        return Colors.grey; // Default to gray for unknown colors
    }
  }
}
