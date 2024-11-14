import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Ensure this import is correct

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  Future<void> _checkAuthentication() async {
    // Simulate a delay to mimic loading time
    await Future.delayed(const Duration(seconds: 2));

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _isAuthenticated = authProvider.isAuthenticated;

    if (mounted) {
      if (_isAuthenticated) {
        _showUserTypeSelection();
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void _showUserTypeSelection() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Ensure the dialog isn't dismissed accidentally
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
