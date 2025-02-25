import 'package:flutter/material.dart';
import '../../models/auth_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  AuthModel? _currentUser;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  AuthModel? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Replace with actual API call
      if (email == "test@test.com" && password == "password") {
        _currentUser = AuthModel(email: email, password: password);
        _isAuthenticated = true;
        _error = null;
      } else {
        _error = "Invalid credentials";
        _isAuthenticated = false;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _isAuthenticated;
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
