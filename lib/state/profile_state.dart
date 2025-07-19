import 'package:flutter/material.dart';

class ProfileState with ChangeNotifier {
  // User profile
  String _userName = "Blind Dela Cruz";
  String _userEmail = "blind.dc@tanaw.com";
  String _userPhone = "+63 912 345 6789";
  String? _userImagePath;

  // Guardian profile
  String _guardianName = "John Doe";
  String _guardianEmail = "john.doe@tanaw.com";
  String _guardianPhone = "+63 998 765 4321";
  String? _guardianImagePath;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String? get userImagePath => _userImagePath;

  String get guardianName => _guardianName;
  String get guardianEmail => _guardianEmail;
  String get guardianPhone => _guardianPhone;
  String? get guardianImagePath => _guardianImagePath;

  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void updateUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  void updateUserPhone(String phone) {
    _userPhone = phone;
    notifyListeners();
  }

  void updateUserImage(String imagePath) {
    _userImagePath = imagePath;
    notifyListeners();
  }

  void updateGuardianName(String name) {
    _guardianName = name;
    notifyListeners();
  }

  void updateGuardianEmail(String email) {
    _guardianEmail = email;
    notifyListeners();
  }

  void updateGuardianPhone(String phone) {
    _guardianPhone = phone;
    notifyListeners();
  }

  void updateGuardianImage(String imagePath) {
    _guardianImagePath = imagePath;
    notifyListeners();
  }
}