// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv package
import 'screens/screens.dart';
import 'providers/auth_provider.dart'; // Ensure this is correct

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env").catchError((error) {
    print('Failed to load .env file: $error');
  });

  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ??
        '', // Use environment variable for Supabase URL
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ??
        '', // Use environment variable for Supabase anonymous key
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turf Booking App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/bookings': (context) => const BookingsScreen(),
        '/customer_dashboard': (context) => CustomerDashboardScreen(),
        '/manager_dashboard': (context) => ManagerDashboardScreen(),
      },
    );
  }
}
