import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
