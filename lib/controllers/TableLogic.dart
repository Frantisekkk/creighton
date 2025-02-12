import 'package:flutter/material.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:provider/provider.dart';

class TableLogic extends ChangeNotifier {
  List<List<Map<String, dynamic>>>? cycleData;
  bool isLoading = true;
  String errorMessage = '';

  TableLogic(BuildContext context) {
    loadCycleData(context);
  }

  void loadCycleData(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    // Check if data is already available
    if (!appState.isLoading && appState.dayData != null) {
      cycleData = appState.dayData?["cycleData"];
      isLoading = false;
      notifyListeners();
      return;
    }

    // If data is not available, fetch it
    fetchCycleData(context);
  }

  Future<void> fetchCycleData(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.isLoading) return; // Prevent duplicate fetching

    try {
      isLoading = true;
      notifyListeners();

      await appState.fetchCycleData();
      cycleData = appState.dayData?["cycleData"];
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
