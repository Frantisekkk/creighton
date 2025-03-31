import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/state/AppState.dart';

class DayLogic extends ChangeNotifier {
  final AppState appState;
  DateTime selectedDate;
  bool _isDisposed = false;

  // Day-specific data fields.
  Color stickerColor;
  bool baby;
  double selectedTemperature;
  bool selectedAbdominalPain;
  String selectedBleeding;
  String selectedMucus;
  String selectedFertility;
  String selectedPeak;
  bool isLoaded = false;

  DayLogic({required this.appState, DateTime? initialDate})
      : selectedDate = initialDate ?? DateTime.now(),
        stickerColor = Colors.grey,
        baby = false,
        selectedTemperature = 0,
        selectedPeak = '',
        selectedAbdominalPain = false,
        selectedBleeding = '',
        selectedMucus = '',
        selectedFertility = '' {
    loadData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Loads the day’s data by fetching it through the AppState API call.
  Future<void> loadData() async {
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    Map<String, dynamic> data = await appState.fetchDayDataForDate(dateStr);

    // Update fields from fetched data. Defaults used if keys are missing.
    stickerColor = data['stickerColor'] ?? Colors.grey;
    baby = data['baby'] ?? false; // load baby flag from data
    selectedBleeding = data['bleeding'] ?? '';
    selectedMucus = data['mucus'] ?? '';
    selectedFertility = data['fertility'] ?? '';
    selectedTemperature = (data['temperature'] is String)
        ? double.tryParse(data['temperature']) ?? 0.0
        : (data['temperature'] ?? 0.0);
    selectedAbdominalPain = data['ab'] ?? false;
    selectedPeak = data['peak'] ?? '';
    isLoaded = true;
    safeNotifyListeners();
  }

  // Computed getter for the base mucus part.
  String get baseMucus {
    if (selectedMucus.isEmpty) return '';
    // For '6' or '8' cases, the base is the first character.
    if (selectedMucus.startsWith('6') || selectedMucus.startsWith('8')) {
      return selectedMucus.substring(0, 1);
    }
    // For '10', if additional characters exist (but not one of the special ones), the base is '10'
    if (selectedMucus.startsWith('10')) {
      // If the full code is one of the complete codes (e.g., '10DL', '10SL', '10WL'), use it entirely.
      if (['10DL', '10SL', '10WL'].contains(selectedMucus)) {
        return selectedMucus;
      } else if (selectedMucus.length > 2) {
        return '10';
      }
      return selectedMucus;
    }
    return selectedMucus;
  }

  // Computed getter for the additional mucus part.
  String get additionalMucus {
    if (selectedMucus.isEmpty) return '';
    if ((selectedMucus.startsWith('6') || selectedMucus.startsWith('8')) &&
        selectedMucus.length > 1) {
      return selectedMucus.substring(1);
    }
    if (selectedMucus.startsWith('10') &&
        selectedMucus.length > 2 &&
        !['10DL', '10SL', '10WL'].contains(selectedMucus)) {
      return selectedMucus.substring(2);
    }
    return '';
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
      isLoaded = false;
      notifyListeners();
      await loadData();
      notifyListeners();
    }
  }

  /// Starts a new cycle by calling the AppState method.
  Future<void> startNewCycle() async {
    await appState.startNewCycle(selectedDate);
    await appState.refreshAllData();
  }

  /// Updates the peak value for the selected date.
  Future<void> updatePeak(String value) async {
    selectedPeak = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updatePeakForDate(dateStr, value);
    await appState.refreshAllData();
  }

  /// Updates the sticker color and baby flag for the selected date.
  Future<void> updateStickerColor(Color newColor, bool newBaby) async {
    stickerColor = newColor;
    baby = newBaby;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateStickerColorForDate(dateStr, newColor, newBaby);
    await appState.refreshAllData();
  }

  /// Updates the temperature for the selected date.
  Future<void> updateTemperature(double newTemp) async {
    selectedTemperature = newTemp;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateTemperatureForDate(dateStr, newTemp);
    await appState.refreshAllData();
  }

  /// Updates the abdominal pain status for the selected date.
  Future<void> updateAbdominalPain(bool value) async {
    selectedAbdominalPain = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateAbdominalPainForDate(dateStr, value);
    await appState.refreshAllData();
  }

  /// Updates the bleeding value for the selected date.
  Future<void> updateBleeding(String value) async {
    selectedBleeding = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateBleedingForDate(dateStr, value);
    await appState.refreshAllData();
  }

  /// Updates the mucus value for the selected date.
  Future<void> updateMucus(String value) async {
    selectedMucus = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateMucusForDate(dateStr, value);
    await appState.refreshAllData();
  }

  /// Updates the fertility value for the selected date.
  Future<void> updateFertility(String value) async {
    selectedFertility = value;
    notifyListeners();
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    await appState.updateFertilityForDate(dateStr, value);
    await appState.refreshAllData();
  }
}
