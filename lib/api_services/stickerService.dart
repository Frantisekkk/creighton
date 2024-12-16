import 'package:flutter/material.dart';
import 'api_service.dart';

class StickerService {
  final ApiService _apiService = ApiService();

  Future<Color> fetchColorByDate(String date) async {
    try {
      // Fetch day data
      final Map<String, dynamic> dayData = await _apiService.fetchDayData(date);

      // Extract the color field (assumed to be in 'sticker')
      final String? colorName = dayData['sticker'] as String?;
      if (colorName != null && colorName.isNotEmpty) {
        return _getColor(colorName);
      } else {
        print('Error: No color found for date $date');
        return Colors.grey; // Default to gray if no color is found
      }
    } catch (e) {
      print('Error fetching color for date $date: $e');
      return Colors.grey; // Default to gray if an error occurs
    }
  }

  Future<List<Color>> fetchColorsForLastWeek() async {
    try {
      // Fetch sticker data for the last week
      final List<Map<String, String>> stickerData =
          await _apiService.fetchStickersForLastWeek();

      // Map the colors and return as a list
      return stickerData.map((data) {
        final String? colorName = data['color'];
        return colorName != null ? _getColor(colorName) : Colors.grey;
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
