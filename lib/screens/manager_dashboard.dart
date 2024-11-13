import 'package:flutter/material.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Dashboard'),
      ),
      body: Center(
        child: Text('Welcome to the Manager Dashboard'),
      ),
    );
  }
}
