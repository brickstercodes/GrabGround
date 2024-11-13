// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Fixed import path

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  // Login function with user type check
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Simulate a user response with the user type
      _user = User(
        id: '1',
        name: 'Test User',
        email: email,
        phone: '1234567890',
        userType:
            'Customer', // Here you would typically get this from the API response
      );

      // Store auth token and user type in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'dummy_token');
      await prefs.setString('user_type', _user!.userType); // Save userType

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register function with user type
  Future<void> register(String email, String password, String userType) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual registration API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Simulate a user registration response
      _user = User(
        id: '1',
        name: 'New User',
        email: email,
        phone: '1234567890',
        userType: userType, // Save the userType from registration
      );

      // Store auth token and user type in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'dummy_token');
      await prefs.setString('user_type', userType); // Save userType

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout function
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_type'); // Remove user type from prefs
    notifyListeners();
  }

  // Check user type on startup
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('user_type');
    if (userType != null) {
      _user = User(
        id: '1', // Placeholder user data
        name: 'Test User',
        email: 'test@example.com',
        phone: '1234567890',
        userType: userType,
      );
    }
    notifyListeners();
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType; // Add userType field

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType, // Initialize userType in the constructor
  });
}
