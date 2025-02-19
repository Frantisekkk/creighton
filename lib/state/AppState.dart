import 'package:flutter/material.dart';
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

  // Add a new method to fetch day data for a specified date string.
  Future<Map<String, dynamic>> fetchDayDataForDate(String dateStr) async {
    try {
      final data = await _apiService.fetchDayData(dateStr);
      if (data.isEmpty) {
        return {
          'stickerColor': Colors.grey,
          'bleeding': 'No data',
          'mucus': 'No data',
          'fertility': 'No data'
        };
      }
      return data;
    } catch (e) {
      print("Error fetching day data for $dateStr: $e");
      return {
        'stickerColor': Colors.grey,
        'bleeding': 'Error',
        'mucus': 'Error',
        'fertility': 'Error'
      };
    }
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

  /// Fetches the list of doctors from the API service.
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      return await _apiService.fetchDoctors();
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }

  /// Fetches the list of consultants from the API service.
  Future<List<Map<String, dynamic>>> fetchConsultants() async {
    try {
      return await _apiService.fetchConsultants();
    } catch (e) {
      throw Exception('Error fetching consultants: $e');
    }
  }

  // -----
  // LOGIN
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
      await fetchCycleData(); // Refresh UI after starting new cycle
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

  // ------------------------
  // Day page day parameters update
  // -----------------------------------
  Future<void> updateTemperatureForDate(
      String dateStr, double temperature) async {
    try {
      await _apiService.updateTemperature(dateStr, temperature);
    } catch (e) {
      print("Error updating temperature: $e");
    }
  }

  Future<void> updateAbdominalPainForDate(String dateStr, bool value) async {
    try {
      await _apiService.updateAbdominalPain(dateStr, value);
    } catch (e) {
      print("Error updating abdominal pain: $e");
    }
  }

  Future<void> updateBleedingForDate(String dateStr, String value) async {
    try {
      await _apiService.updateBleeding(dateStr, value);
    } catch (e) {
      print("Error updating bleeding: $e");
    }
  }

  Future<void> updateMucusForDate(String dateStr, String value) async {
    try {
      await _apiService.updateMucus(dateStr, value);
    } catch (e) {
      print("Error updating mucus: $e");
    }
  }

  Future<void> updateFertilityForDate(String dateStr, String value) async {
    try {
      await _apiService.updateFertility(dateStr, value);
    } catch (e) {
      print("Error updating fertility: $e");
    }
  }
}
