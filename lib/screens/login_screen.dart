// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  // Add your Supabase auth logic here
                  await Supabase.instance.client.auth.signInWithOAuth(
                    OAuthProvider.google,
                    redirectTo:
                        'io.supabase.flutterquickstart://login-callback/',
                    authScreenLaunchMode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error logging in: $e')),
                  );
                }
              },
              child: Text('Login with Google'),
            ),
            // Add other login options as needed
          ],
        ),
      ),
    );
  }
}
