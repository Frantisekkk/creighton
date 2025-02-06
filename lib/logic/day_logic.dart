import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api_services/api_service.dart';

class DayLogic extends ChangeNotifier {
  final ApiService apiService = ApiService();

  late DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;

  String selectedBleeding = '';
  String selectedMucus = '';
  String selectedFertility = '';
  double selectedTemperature = 36.0;
  bool selectedAbdominalPain = false;
  Color stickerColor = Colors.grey;

  DayLogic(DateTime initialDate) {
    _selectedDate = initialDate;
    loadDayState();
  }

  /// Loads the state for the current selected date.
  Future<void> loadDayState() async {
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    try {
      final data = await apiService.fetchDayData(selectedDateStr);
      selectedBleeding = data['bleeding'] ?? '';
      selectedMucus = data['mucus'] ?? '';
      selectedFertility = data['fertility'] ?? '';
      selectedAbdominalPain = data['ab'] ?? false;
      selectedTemperature =
          double.tryParse(data['temperature']?.toString() ?? '36.0') ?? 36.0;
      stickerColor = data['stickerColor'] ?? Colors.grey;
    } catch (e) {
      print('Error loading day state: $e');
    }
    notifyListeners(); // This tells the UI to update
  }

  /// Selects a new date and reloads the state.
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      loadDayState();
    }
  }

  Future<void> updateTemperature(double temperature) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    await apiService.updateTemperature(dateStr, temperature);
    selectedTemperature = temperature;
    notifyListeners();
  }

  Future<void> updateAbdominalPain(bool value) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    await apiService.updateAbdominalPain(dateStr, value);
    selectedAbdominalPain = value;
    notifyListeners();
  }

  Future<void> updateBleeding(String value) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    await apiService.updateBleeding(dateStr, value);
    selectedBleeding = value;
    notifyListeners();
  }

  Future<void> updateMucus(String value) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    await apiService.updateMucus(dateStr, value);
    selectedMucus = value;
    notifyListeners();
  }

  Future<void> updateFertility(String value) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    await apiService.updateFertility(dateStr, value);
    selectedFertility = value;
    notifyListeners();
  }
}
