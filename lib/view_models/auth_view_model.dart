import 'package:fave_films_2/data/service_locator.dart';
import 'package:fave_films_2/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = ServiceLocator.instance<AuthService>();

  Future signUp(String email, String password) async {
    String? result = await _authService.signUp(email, password);
    notifyListeners();
    return result;
  }

  Future signIn(String email, String password) async {
    String? result = await _authService.signIn(email, password);
    notifyListeners();
    return result;
  }

  Future signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }
}
