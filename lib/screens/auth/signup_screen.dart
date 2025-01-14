import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  UserType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const AppTextField(
                      label: 'First Name',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    // Add other fields as shown in the mockup
                    // ...

                    const SizedBox(height: 16),
                    DropdownButtonFormField<UserType>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        hintText: 'Are you a customer or manager?',
                      ),
                      items: UserType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedType = value);
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle sign up
                        }
                      },
                      child: const Text('Create account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum UserType { customer, manager }
