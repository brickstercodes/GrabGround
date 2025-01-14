import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStateProvider extends ChangeNotifier {
  bool _isNewSignIn = false;

  bool get isNewSignIn => _isNewSignIn;

  void setNewSignIn(bool value) {
    _isNewSignIn = value;
    notifyListeners();
  }

  Future<String?> getUserType() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      debugPrint('Fetching user type for ID: ${user.id}');

      final response = await Supabase.instance.client
          .from('profiles')
          .select('user_type')
          .eq('user_id', user.id)
          .maybeSingle();

      debugPrint('Profile response: $response');

      if (response == null || response['user_type'] == null) {
        debugPrint('No user type set yet');
        return null;
      }

      final userType = response['user_type'] as String;
      debugPrint('Found user type: $userType');
      return userType;
    } catch (e) {
      debugPrint('Error getting user type: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }
}
