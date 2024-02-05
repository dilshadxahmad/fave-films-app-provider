import 'package:flutter/material.dart';

class FormValidationViewModel with ChangeNotifier {
  bool _isFormValid = false;

  bool get isFormValid => _isFormValid;

  void updateFormValidity(bool isValid) {
    _isFormValid = isValid;
    notifyListeners();
  }
}
