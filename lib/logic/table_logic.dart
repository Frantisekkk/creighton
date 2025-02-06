import 'package:flutter/material.dart';
import '../api_services/api_service.dart';

class TableLogic extends ChangeNotifier {
  final ApiService apiService = ApiService();

  List<List<Map<String, dynamic>>>? cycleData;
  bool isLoading = true;
  String errorMessage = '';

  TableLogic() {
    loadCycleData();
  }

  Future<void> loadCycleData() async {
    try {
      final data = await apiService.fetchCycleData();
      cycleData = data;
      isLoading = false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
    }
    notifyListeners();
  }
}
