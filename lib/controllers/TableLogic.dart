import 'package:flutter/material.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:provider/provider.dart';

class TableLogic extends ChangeNotifier {
  List<List<Map<String, dynamic>>>? cycleData;
  bool isLoading = true;
  String errorMessage = '';

  TableLogic();

  void loadCycleData(BuildContext context) {
    Future.microtask(
        () => _loadData(context)); // Schedules async task outside build
  }

  Future<void> _loadData(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (!appState.isLoading && appState.cycleData != null) {
      cycleData = appState.cycleData;
      isLoading = false;
      print("TableLogic._loadData: Cycle data loaded: $cycleData");
      notifyListeners();
      return;
    }

    await fetchCycleData(context);
  }

  Future<void> fetchCycleData(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

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
}
