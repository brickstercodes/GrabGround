// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv package
import 'features/chat/screens/chat_screen.dart';
import 'screens/billing_details_screen.dart';
import 'screens/help_screen.dart';
import 'screens/screens.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';
import 'providers/auth_state_provider.dart';
import 'providers/theme_provider.dart';
import 'models/booking_flow.dart';
import 'screens/analytics_screen.dart';
import 'providers/user_provider.dart';
// Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  debugPrint('=== App Starting ===');

  await dotenv.load(fileName: ".env");
  debugPrint('Environment loaded');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    debug: true,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
  );
  debugPrint('Supabase initialized');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ),
        ChangeNotifierProvider(create: (_) => AuthStateProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final session = snapshot.data!.session;
            if (session != null) {
              return const SelectTypeScreen();
            }
          }
          return const AuthScreen();
        },
      ),
      routes: {
        '/select_type': (context) => const SelectTypeScreen(),
        '/customer_dashboard': (context) => const CustomerDashboardScreen(),
        '/manager_dashboard': (context) => const ManagerDashboardScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/help': (context) => const HelpScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/billing': (context) => BillingDetailsScreen(
              booking:
                  ModalRoute.of(context)!.settings.arguments as BookingFlow,
            ),
        '/analytics': (context) => const AnalyticsScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
