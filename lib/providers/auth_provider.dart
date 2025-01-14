// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

enum UserType { customer, manager }

class AuthProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  UserType? _userType;
  bool _isLoading = false;

  UserType? get userType => _userType;
  bool get isLoading => _isLoading;

  Future<UserType?> checkUserType() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from('user_profiles')
          .select('user_type')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null && response['user_type'] != null) {
        _userType = UserType.values.firstWhere(
          (type) => type.name == response['user_type'],
        );
        return _userType;
      }
      return null;
    } catch (e) {
      debugPrint('Error checking user type: $e');
      return null;
    }
  }

  Future<void> setUserType(UserType type) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('user_profiles').upsert(
        {
          'user_id': user.id,
          'user_type': type.name,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id',
      );

      _userType = type;
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting user type: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _userType = null;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: Platform.isIOS
            ? 'io.supabase.flutterquickstart://login-callback/'
            : null,
        authScreenLaunchMode: LaunchMode.inAppWebView,
      );

      if (!response) {
        throw 'Google Sign In failed or was cancelled';
      }

      // Check if user exists and has a type
      final userType = await checkUserType();
      if (userType == null) {
        // Handle new user
        debugPrint('New user, needs to select type');
      }
    } catch (e) {
      debugPrint('Error in Google Sign In: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthResponse> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw 'Sign up failed';
      }

      return response;
    } catch (e) {
      debugPrint('Error in sign up: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
