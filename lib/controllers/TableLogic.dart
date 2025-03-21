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

  // Navigate to Edit Day screen
  void navigateToEditDay(BuildContext context, DateTime date) {
    appState.setPage(2, date: date);
  }

  // Handle Creating a New Cycle
  Future<void> createNewCycle(BuildContext context, DateTime date) async {
    try {
      await appState.startNewCycle(date);
      await fetchCycleData(); // Refresh table after creation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New cycle created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating cycle: $e')),
      );
    }
  }

  // Handle Deleting a Cycle
  Future<void> deleteCycle(
      BuildContext context, DateTime cycleStartDate) async {
    try {
      await appState.undoCycle(cycleStartDate);
      await fetchCycleData(); // Refresh table after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cycle deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting cycle: $e')),
      );
    }
  }

  @override
  void dispose() {
    appState
        .removeListener(_onAppStateChanged); // Remove listener when destroyed
    super.dispose();
  }
}
