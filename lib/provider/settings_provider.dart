import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool showShortOnly = false;
  bool showTrendingOnly = false;

  void toggleShortOnly(bool value) {
    showShortOnly = value;
    notifyListeners();
  }

  void toggleTrendingOnly(bool value) {
    showTrendingOnly = value;
    notifyListeners();
  }
}
