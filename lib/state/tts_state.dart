import 'package:flutter/material.dart';

class TtsState with ChangeNotifier {
  bool _isTtsEnabled = true;

  bool get isTtsEnabled => _isTtsEnabled;

  void setTtsEnabled(bool isEnabled) {
    _isTtsEnabled = isEnabled;
    notifyListeners();
  }
} 