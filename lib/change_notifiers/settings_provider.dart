import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {

  bool _isDarkMode = false;
  bool _isGridView = true;

  bool get isDarkMode => _isDarkMode;
  bool get isGridView => _isGridView;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleGridView(bool value) {
    _isGridView = value;
    notifyListeners();
  }
}