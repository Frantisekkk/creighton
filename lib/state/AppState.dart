import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/api_services/ApiService.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // ----------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------
  DateTime _selectedDate = DateTime.now();
  int _selectedIndex = 1;
  String? _userEmail;

  //for cycle
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //  Data storage
  Map<String, dynamic>? _dayData;
  List<Color>? _weeklyStickers;
  Map<String, dynamic>? _userProfile;
  bool _isAuthenticated = false;

  //  Getters for UI
  Map<String, dynamic>? get dayData => _dayData;
  List<Color>? get weeklyStickers => _weeklyStickers;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;

  // ----------------------------------------------------
  // METHODS
  // ----------------------------------------------------

  // bottom navigation switch / index setter
  int get selectedIndex => _selectedIndex;
  DateTime get selectedDate => _selectedDate;

  void setPage(int index, {DateTime? date}) {
    _selectedIndex = index;
    if (date != null) {
      _selectedDate = date;
    }
    notifyListeners(); // Updates UI
  }

  // Fetch Today's Data (Home Page)
  Future<void> fetchTodayData() async {
    String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      _dayData = await _apiService.fetchDayData(todayStr);

      // If no data exists, set a default grey sticker and empty details
      if (_dayData == null || _dayData!.isEmpty) {
        _dayData = {
          'stickerColor': Colors.grey,
          'bleeding': 'No data',
          'mucus': 'No data',
          'fertility': 'No data'
        };
      }
    } catch (e) {
      print("Error fetching today's data: $e");

      // Set defaults in case of an error
      _dayData = {
        'stickerColor': Colors.grey,
        'bleeding': 'Error',
        'mucus': 'Error',
        'fertility': 'Error'
      };
    }
    notifyListeners();
  }

  //  Fetch Weekly Stickers (Calendar Row in Home)
  Future<void> fetchWeeklyStickers() async {
    try {
      _weeklyStickers = await _apiService.fetchStickersForLastWeek();

      // Ensure weeklyStickers is always 7 items long
      if (_weeklyStickers == null || _weeklyStickers!.length < 7) {
        _weeklyStickers = List.filled(7, Colors.grey);
      }
    } catch (e) {
      print("Error fetching weekly stickers: $e");
      _weeklyStickers = List.filled(7, Colors.grey);
    }
    notifyListeners();
  }

  //  Fetch User Profile
  Future<void> fetchUserProfile() async {
    try {
      if (_userEmail == null) return;
      _userProfile = await _apiService.fetchUserProfile(_userEmail!);
      notifyListeners();
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }
  // -----
  //REGISTRATION
  // -----

  //  Handle Authentication
  Future<bool> login(String email, String password) async {
    try {
      bool success = await _apiService.loginUser(email, password);
      if (success) {
        _isAuthenticated = true;
        _userEmail = email;
        await fetchUserProfile();
        notifyListeners();
      }
      return success;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _userProfile = null;
    notifyListeners();
  }

  // ----------
  // CYCLE
  // ----------

  Future<void> startNewCycle() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.startNewCycle();
    } catch (e) {
      print('Error starting new cycle: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> undoCycle() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.undoCycle();
    } catch (e) {
      print('Error undoing cycle: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteLastCycle() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.deleteLastCycle();
    } catch (e) {
      print('Error deleting last cycle: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCycleData() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.fetchCycleData();
    } catch (e) {
      print('Error fetching cycle data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
