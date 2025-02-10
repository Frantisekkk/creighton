import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/api_services/ApiService.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // ----------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------
  DateTime _selectedDate = DateTime.now();
  int _selectedIndex = 1; // Default: HomePage

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

  //  Fetch Today's Data (Home Page)
  Future<void> fetchTodayData() async {
    String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      _dayData = await _apiService.fetchDayData(todayStr);
      notifyListeners();
    } catch (e) {
      print("Error fetching today's data: $e");
    }
  }

  //  Fetch Weekly Stickers (Calendar Row in Home)
  Future<void> fetchWeeklyStickers() async {
    try {
      _weeklyStickers = await _apiService.fetchStickersForLastWeek();
      notifyListeners();
    } catch (e) {
      print("Error fetching weekly stickers: $e");
      _weeklyStickers = List.filled(7, Colors.grey);
    }
  }

  //  Fetch User Profile
  Future<void> fetchUserProfile(int userId) async {
    try {
      _userProfile = await _apiService.fetchUserProfile(userId);
      notifyListeners();
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  //  Handle Authentication
  Future<bool> login(String email, String password) async {
    try {
      bool success = await _apiService.loginUser(email, password);
      if (success) {
        _isAuthenticated = true;
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
}
