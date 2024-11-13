import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart'; // Ensure this import is correct

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String _selectedUserType = 'Customer'; // Default selection
  bool _isAuthenticated = false; // Keep track of authentication

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Simulate checking the authentication and load user data
  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating loading

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _isAuthenticated = authProvider.isAuthenticated; // Get auth status

    if (mounted) {
      if (_isAuthenticated) {
        // Proceed to the next step after authentication
        _showUserTypeSelection();
      } else {
        // If not authenticated, navigate to the login screen
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  // Show dropdown for user type selection
  void _showUserTypeSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select User Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedUserType,
                items: <String>['Customer', 'Manager'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUserType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the appropriate dashboard based on user type
                  if (_selectedUserType == 'Customer') {
                    Navigator.pushReplacementNamed(
                        context, '/customer_dashboard');
                  } else if (_selectedUserType == 'Manager') {
                    Navigator.pushReplacementNamed(
                        context, '/manager_dashboard');
                  }
                },
                child: const Text('Proceed'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
