import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_state_provider.dart';

class SelectTypeScreen extends StatefulWidget {
  const SelectTypeScreen({super.key});

  @override
  State<SelectTypeScreen> createState() => _SelectTypeScreenState();
}

class _SelectTypeScreenState extends State<SelectTypeScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    final userType = await context.read<AuthStateProvider>().getUserType();
    if (userType != null && mounted) {
      Navigator.pushReplacementNamed(
        context,
        userType == 'customer' ? '/customer_dashboard' : '/manager_dashboard',
      );
    }
  }

  Future<void> _setUserType(String type) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      debugPrint('Current user ID: ${user.id}');
      debugPrint('Attempting to set user type: $type');

      // First check if profile exists
      final existingProfile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      debugPrint('Existing profile check result: $existingProfile');

      if (existingProfile == null) {
        debugPrint('Creating new profile...');
        final insertResult = await Supabase.instance.client
            .from('profiles')
            .insert({
              'user_id': user.id,
              'user_type': type,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();
        debugPrint('Insert result: $insertResult');
      } else {
        debugPrint('Updating existing profile...');
        final updateResult = await Supabase.instance.client
            .from('profiles')
            .update({
              'user_type': type,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', user.id)
            .select()
            .single();
        debugPrint('Update result: $updateResult');
      }

      if (mounted) {
        debugPrint('Profile updated, navigating to $type dashboard');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Add a small delay to ensure the snackbar is visible
        await Future.delayed(const Duration(milliseconds: 500));

        // Navigate to appropriate dashboard
        if (mounted) {
          final route =
              type == 'customer' ? '/customer_dashboard' : '/manager_dashboard';
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
            (route) => false, // This removes all previous routes from the stack
          );
        }
      }
    } catch (e) {
      debugPrint('Error setting user type: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Account Type'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildTypeCard(
              'Customer',
              'Book and manage turf reservations',
              Icons.person,
              () => _setUserType('customer'),
            ),
          ),
          Expanded(
            child: _buildTypeCard(
              'Manager',
              'Manage your turf facility',
              Icons.business,
              () => _setUserType('manager'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(
      String title, String description, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 64),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
