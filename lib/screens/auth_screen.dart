import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      debugPrint('=== START: Google Sign In Process ===');

      final response = await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
        queryParams: {
          'access_type': 'offline',
          'prompt': 'consent',
        },
      );

      debugPrint('OAuth Response: $response');

      if (!response) {
        debugPrint('ERROR: OAuth sign in failed to initiate');
        throw Exception('Failed to initiate OAuth sign in');
      }

      debugPrint('SUCCESS: OAuth sign in initiated');
    } catch (e) {
      debugPrint('ERROR in _handleGoogleSignIn: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing in: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
          onPressed: () => _handleGoogleSignIn(context),
        ),
      ),
    );
  }
}
