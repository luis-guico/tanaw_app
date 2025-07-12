import 'package:flutter/material.dart';

class GuardianModeState with ChangeNotifier {
  bool _isGuardianModeEnabled = false;

  bool get isGuardianModeEnabled => _isGuardianModeEnabled;

  void setGuardianMode(bool isEnabled) {
    _isGuardianModeEnabled = isEnabled;
    notifyListeners();
  }
} 