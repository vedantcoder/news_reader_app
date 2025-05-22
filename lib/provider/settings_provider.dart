import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  bool showShortOnly = false;
  bool showTrendingOnly = false;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleShortOnly(bool value) {
    showShortOnly = value;
    notifyListeners();
  }

  void toggleTrendingOnly(bool value) {
    showTrendingOnly = value;
    notifyListeners();
  }
}