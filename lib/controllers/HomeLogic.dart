import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/AppState.dart';

class HomeLogic extends ChangeNotifier {
  final AppState appState;
  final DateTime today;
  bool _isDisposed = false;

  HomeLogic({required this.appState, DateTime? initialDate})
      : today = initialDate ?? DateTime.now() {
    loadData();
  }

  // Expose the home page data from AppState.
  Map<String, dynamic>? get dayData => appState.dayData;
  List<Color>? get weeklyStickers => appState.weeklyStickers;
  List<List<Map<String, dynamic>>>? get cycleData => appState.cycleData;

  @override
  void dispose() {
    _isDisposed = true; // <-- Mark as disposed
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

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
    safeNotifyListeners();
  }

  /// Loads the sticker colors for the last week by delegating to AppState.
  Future<void> loadWeeklyStickers() async {
    try {
      await appState.fetchWeeklyStickers();
    } catch (e) {
      print("Error loading weekly stickers: $e");
    }
    safeNotifyListeners();
  }

  // Compute the current cycle day.
  int getCurrentCycleDay() {
    // Use the dayData if today’s record is available
    if (dayData != null &&
        dayData!['day_order'] != null &&
        dayData!['day_order'] > 0) {
      return dayData!['day_order'];
    }
    // Otherwise, compute based on the start date of the current cycle
    else if (cycleData != null && cycleData!.isNotEmpty) {
      final currentCycle = cycleData!.last;
      if (currentCycle.isNotEmpty) {
        // Assuming the first record in the current cycle has a 'date' field
        DateTime startDate = DateTime.parse(currentCycle.first['date']);
        int diffDays = DateTime.now().difference(startDate).inDays + 1;
        return diffDays;
      }
    }
    // Fallback if no data is available
    return 0;
  }
}
