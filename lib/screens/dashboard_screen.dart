import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'customer_dashboard.dart';
import 'manager_dashboard.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Automatically show the appropriate dashboard based on user type
        if (authProvider.userType == UserType.customer) {
          return const CustomerDashboardScreen();
        } else if (authProvider.userType == UserType.manager) {
          return const ManagerDashboardScreen();
        }

        // Show selection screen only if user type is not set
        return Scaffold(
          appBar: AppBar(
            title: Text('Dashboard'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerDashboardScreen(),
                      ),
                    );
                  },
                  child: Text('Customer View'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManagerDashboardScreen(),
                      ),
                    );
                  },
                  child: Text('Manager View'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
