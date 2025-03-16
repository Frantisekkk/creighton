import 'package:flutter/material.dart';
import 'package:flutter_application_1/state/AppState.dart';

class TableLogic extends ChangeNotifier {
  final AppState appState;
  List<List<Map<String, dynamic>>>? cycleData;
  bool isLoading = true;
  String errorMessage = '';

  TableLogic({required this.appState}) {
    appState.addListener(_onAppStateChanged); // Listen to changes in AppState
    loadCycleData();
  }

  void _onAppStateChanged() {
    cycleData = appState.cycleData;
    notifyListeners(); // Notify the UI to rebuild
  }

  void loadCycleData() {
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    if (!appState.isLoading && appState.cycleData != null) {
      cycleData = appState.cycleData;
      isLoading = false;
      notifyListeners();
      return;
    }
    await fetchCycleData();
  }

  Future<void> fetchCycleData() async {
    if (appState.isLoading) return; // Prevent duplicate fetching

    try {
      isLoading = true;
      notifyListeners();

      await appState.fetchCycleData();
      cycleData = appState.cycleData;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    appState
        .removeListener(_onAppStateChanged); // Remove listener when destroyed
    super.dispose();
  }
}
