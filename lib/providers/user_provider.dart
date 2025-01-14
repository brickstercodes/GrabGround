import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  String _userName = '';
  String get userName => _userName;

  Future<void> fetchUserName() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Get user name from user metadata
        final userMetadata = user.userMetadata;
        if (userMetadata != null) {
          _userName = userMetadata['full_name'] ??
              userMetadata['name'] ??
              user.email?.split('@')[0] ??
              'User';
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    }
  }
}
