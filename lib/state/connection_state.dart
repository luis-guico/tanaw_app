import 'package:flutter/material.dart';

class ConnectionState with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  void toggleConnection() {
    _isConnected = !_isConnected;
    notifyListeners();
  }
}
