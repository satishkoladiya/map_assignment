import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  String _otp = "123456";
  User? _user;

  String get otp => _otp;
  User? get user => _user;

  void setOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  bool validateOtp(String enteredOtp) {
    return _otp == enteredOtp;
  }
}
