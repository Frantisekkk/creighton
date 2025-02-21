import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/state/AppState.dart';

class DayLogic extends ChangeNotifier {
  final AppState appState;
  DateTime selectedDate;

  // Day-specific data fields.
  Color stickerColor;
  double selectedTemperature;
  bool selectedAbdominalPain;
  String selectedBleeding;
  String selectedMucus;
  String selectedFertility;
  bool isLoaded = false;

  DayLogic({required this.appState, DateTime? initialDate})
      : selectedDate = initialDate ?? DateTime.now(),
        stickerColor = Colors.grey,
        selectedTemperature = 0,
        selectedAbdominalPain = false,
        selectedBleeding = '',
        selectedMucus = '',
        selectedFertility = '' {
    loadData();
  }

  /// Loads the day’s data by fetching it through the AppState API call.
  Future<void> loadData() async {
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    Map<String, dynamic> data = await appState.fetchDayDataForDate(dateStr);
    // Update fields from fetched data. If keys are missing, defaults are used.
    stickerColor = data['stickerColor'] ?? Colors.grey;
    selectedBleeding = data['bleeding'] ?? '';
    selectedMucus = data['mucus'] ?? '';
    selectedFertility = data['fertility'] ?? '';
    selectedTemperature = data['temperature'] ?? 0.0;
    selectedAbdominalPain = data['ab'] ?? false;
    isLoaded = true;
    notifyListeners();
  }

  /// Opens a date picker to select a new date and loads its data.
  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      await loadData();
    }
  }

  /// Updates the temperature for the selected date.
  Future<void> updateTemperature(double newTemp) async {
    selectedTemperature = newTemp;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateTemperatureForDate(dateStr, newTemp);
  }

  /// Updates the abdominal pain status for the selected date.
  Future<void> updateAbdominalPain(bool value) async {
    selectedAbdominalPain = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateAbdominalPainForDate(dateStr, value);
  }

  /// Updates the bleeding value for the selected date.
  Future<void> updateBleeding(String value) async {
    selectedBleeding = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateBleedingForDate(dateStr, value);
  }

  /// Updates the mucus value for the selected date.
  Future<void> updateMucus(String value) async {
    selectedMucus = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateMucusForDate(dateStr, value);
  }

  /// Updates the fertility value for the selected date.
  Future<void> updateFertility(String value) async {
    selectedFertility = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateFertilityForDate(dateStr, value);
  }
}
