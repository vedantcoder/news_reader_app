import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool showShortOnly = false;
  bool showTrendingOnly = false;

  SettingsProvider() {
    _loadSettings(); // Load on startup
  }

  void toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  void toggleShortOnly(bool value) {
    showShortOnly = value;
    notifyListeners();
  }

  void toggleTrendingOnly(bool value) {
    showTrendingOnly = value;
    notifyListeners();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}