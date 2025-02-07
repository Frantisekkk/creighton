import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api_services/ApiService.dart';

class HomeLogic extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final DateTime today;

  /// Contains the data for the “color display container” on the HomePage.
  Map<String, dynamic>? dayData;

  /// Contains the colors for the weekly stickers row.
  List<Color>? weeklyStickers;

  HomeLogic({DateTime? initialDate}) : today = initialDate ?? DateTime.now() {
    loadData();
  }

  /// Loads both the day data and the weekly stickers.
  Future<void> loadData() async {
    await Future.wait([loadDayData(), loadWeeklyStickers()]);
  }

  /// Loads data for today’s date.
  Future<void> loadDayData() async {
    final todayStr = DateFormat('yyyy-MM-dd').format(today);
    try {
      dayData = await apiService.fetchDayData(todayStr);
    } catch (e) {
      print("Error loading day data: $e");
      dayData = {};
    }
    notifyListeners();
  }

  /// Loads the sticker colors for the last week.
  Future<void> loadWeeklyStickers() async {
    try {
      weeklyStickers = await apiService.fetchStickersForLastWeek();
    } catch (e) {
      print("Error loading weekly stickers: $e");
      weeklyStickers = List.filled(7, Colors.grey);
    }
    notifyListeners();
  }
}
