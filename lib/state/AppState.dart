import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_services/ApiService.dart';
import 'package:intl/intl.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  AppState() {
    checkLoginStatus();
  }

  // ----------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------
  DateTime _selectedDate = DateTime.now();
  int _selectedIndex = 1;
  String? _userEmail;

  // For cycle operations
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Data storage
  Map<String, dynamic> _dayData = {
    'stickerColor': Colors.grey,
    'bleeding': 'No data',
    'mucus': 'No data',
    'fertility': 'No data',
    'ab': false,
  };

  List<Color>? _weeklyStickers;
  Map<String, dynamic>? _userProfile;
  bool _isAuthenticated = false;
  List<List<Map<String, dynamic>>>? _cycleData;

  // Getters for UI
  Map<String, dynamic>? get dayData => _dayData;
  List<Color>? get weeklyStickers => _weeklyStickers;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isAuthenticated => _isAuthenticated;
  set isAuthenticated(bool value) {
    _isAuthenticated = value;
  }

  List<List<Map<String, dynamic>>>? get cycleData => _cycleData;
  String? get userEmail => _userEmail;
  int get selectedIndex => _selectedIndex;
  DateTime get selectedDate => _selectedDate;

  // ----------------------------------------------------
  // METHODS
  // ----------------------------------------------------

  // Bottom navigation index/page setter
  void setPage(int index, {DateTime? date}) {
    _selectedIndex = index;
    if (date != null) {
      _selectedDate = date;
    } else if (index == 1) {
      // Reset to today when navigating back to homepage
      _selectedDate = DateTime.now();
      fetchDayDataForDate(DateFormat('yyyy-MM-dd').format(_selectedDate));
    }
    notifyListeners();
  }

  // ----------------------------------------------------
  // Day Data Methods
  // ----------------------------------------------------

  // Fetch day data for a specified date string.
  Future<Map<String, dynamic>> fetchDayDataForDate(String dateStr) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        print("Error: Token is null");
        return {};
      }
      final data = await _apiService.fetchDayData(dateStr, token: token);
      _dayData = data.isEmpty
          ? {
              'stickerColor': Colors.grey,
              'bleeding': 'No data',
              'mucus': 'No data',
              'fertility': 'No data',
              'ab': false,
            }
          : data;
      notifyListeners();
      return _dayData;
    } catch (e) {
      print("Error fetching day data for $dateStr: $e");
      _dayData = {
        'stickerColor': Colors.grey,
        'bleeding': 'Error',
        'mucus': 'Error',
        'fertility': 'Error',
        'ab': false,
      };
      notifyListeners();
      return _dayData;
    }
  }

  // Fetch weekly stickers for the calendar row in Home.
  Future<void> fetchWeeklyStickers() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        print("Error: Token is null");
        _weeklyStickers = List.filled(7, Colors.grey);
      } else {
        _weeklyStickers =
            await _apiService.fetchStickersForLastWeek(token: token);
      }
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

  // ----------------------------------------------------
  // User Profile & Authentication Methods
  // ----------------------------------------------------

  // Fetch User Profile using the token.
  Future<void> fetchUserProfile() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        print("Error: Token is null");
        return;
      }
      _userProfile = await _apiService.fetchUserProfile(token: token);
      notifyListeners();
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  /// Registers a new user by calling the API service.
  Future<bool> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String birthNumber,
    int age,
    String phone,
    String doctor,
    String consultant,
  ) async {
    try {
      bool success = await _apiService.registerUser(
        firstName,
        lastName,
        email,
        password,
        birthNumber,
        age,
        phone,
        doctor,
        consultant,
      );

      if (success) {
        _isAuthenticated = true;
        _userEmail = email;
        await fetchUserProfile();
        notifyListeners();
      }
      return success;
    } catch (e) {
      print("Registration error: $e");
      return false;
    }
  }

  /// Fetch the list of doctors.
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      return await _apiService.fetchDoctors();
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }

  /// Fetch the list of consultants.
  Future<List<Map<String, dynamic>>> fetchConsultants() async {
    try {
      return await _apiService.fetchConsultants();
    } catch (e) {
      throw Exception('Error fetching consultants: $e');
    }
  }

  // Handle user login.
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

  Future<void> checkLoginStatus() async {
    final token = await _apiService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  void logout() async {
    _isAuthenticated = false;
    _userProfile = null;
    _dayData = {
      'stickerColor': Colors.grey,
      'bleeding': 'No data',
      'mucus': 'No data',
      'fertility': 'No data',
      'ab': false,
    };
    _weeklyStickers = null;
    _cycleData = null;
    _userEmail = null;

    // Call API service to remove JWT from local storage
    await _apiService.logout();

    notifyListeners();
  }

  // ----------------------------------------------------
  // Cycle Methods
  // ----------------------------------------------------

  Future<void> startNewCycle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await _apiService.getToken();
      if (token == null) throw Exception("Token is null");
      await _apiService.startNewCycle(token: token);
      await fetchCycleData(); // Refresh UI after starting a new cycle
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
      final token = await _apiService.getToken();
      if (token == null) throw Exception("Token is null");
      await _apiService.undoCycle(token: token);
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
      final token = await _apiService.getToken();
      if (token == null) throw Exception("Token is null");
      await _apiService.deleteLastCycle(token: token);
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
      final token = await _apiService.getToken();
      if (token == null) throw Exception("Token is null");
      _cycleData = await _apiService.fetchCycleData(token: token);
      if (_cycleData == null || _cycleData!.isEmpty) {
        _cycleData = []; // No cycles yet, so an empty list.
      }
    } catch (e) {
      print('Error fetching cycle data: $e');
      _cycleData = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ----------------------------------------------------
  // Day Parameter Update Methods
  // ----------------------------------------------------

  Future<void> updateTemperatureForDate(
      String dateStr, double temperature) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        print("Error: Token is null");
        return;
      }
      await _apiService.updateTemperature(dateStr, temperature, token: token);
    } catch (e) {
      print("Error updating temperature: $e");
    }
  }

  Future<void> updateAbdominalPainForDate(String dateStr, bool value) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        print("Error: Token is null");
        return;
      }
      await _apiService.updateAbdominalPain(dateStr, value, token: token);
    } catch (e) {
      print("Error updating abdominal pain: $e");
    }
  }

  Future<void> updateBleedingForDate(String dateStr, String value) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        print("Error: Token is null");
        return;
      }
      await _apiService.updateBleeding(dateStr, value, token: token);
    } catch (e) {
      print("Error updating bleeding: $e");
    }
  }

  Future<void> updateMucusForDate(String dateStr, String value) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        print("Error: Token is null");
        return;
      }
      await _apiService.updateMucus(dateStr, value, token: token);
    } catch (e) {
      print("Error updating mucus: $e");
    }
  }

  Future<void> updateFertilityForDate(String dateStr, String value) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        print("Error: Token is null");
        return;
      }
      await _apiService.updateFertility(dateStr, value, token: token);
    } catch (e) {
      print("Error updating fertility: $e");
    }
  }
}
