import 'package:flutter/material.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TableLogic extends ChangeNotifier {
  final AppState appState;
  List<List<Map<String, dynamic>>>? cycleData;
  bool isLoading = true;
  String errorMessage = '';

  TableLogic({required this.appState}) {
    appState.addListener(_onAppStateChanged);
    loadCycleData();
  }

  void _onAppStateChanged() {
    cycleData = appState.cycleData;
    notifyListeners();
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
    if (appState.isLoading) return;

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

  void navigateToEditDay(BuildContext context, DateTime date) {
    appState.setPage(2, date: date);
  }

  Future<void> createNewCycle(BuildContext context, DateTime date) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      await appState.startNewCycle(date);
      await fetchCycleData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.new_cycle_success)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations.new_cycle_error}: $e')),
      );
    }
  }

  Future<void> deleteCycle(
      BuildContext context, DateTime cycleStartDate) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      await appState.undoCycle(cycleStartDate);
      await fetchCycleData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.cycle_deleted_success)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations.cycle_delete_error}: $e')),
      );
    }
  }

  @override
  void dispose() {
    appState.removeListener(_onAppStateChanged);
    super.dispose();
  }
}
