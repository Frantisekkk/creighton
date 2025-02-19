import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/AppState.dart';

class HomeLogic extends ChangeNotifier {
  final AppState appState;
  final DateTime today;

  HomeLogic({required this.appState, DateTime? initialDate})
      : today = initialDate ?? DateTime.now() {
    loadData();
  }

  // Expose the home page data from AppState.
  Map<String, dynamic>? get dayData => appState.dayData;
  List<Color>? get weeklyStickers => appState.weeklyStickers;

  /// Loads both the day data and the weekly stickers.
  Future<void> loadData() async {
    await Future.wait([loadDayData(), loadWeeklyStickers()]);
  }

  /// Loads data for today by delegating to AppState.
  Future<void> loadDayData() async {
    final todayStr = DateFormat('yyyy-MM-dd').format(today);
    try {
      await appState.fetchDayDataForDate(todayStr);
    } catch (e) {
      print("Error loading day data: $e");
    }
    notifyListeners();
  }

  /// Loads the sticker colors for the last week by delegating to AppState.
  Future<void> loadWeeklyStickers() async {
    try {
      await appState.fetchWeeklyStickers();
    } catch (e) {
      print("Error loading weekly stickers: $e");
    }
    notifyListeners();
  }
}
