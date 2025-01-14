import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class to manage environment variables
class EnvConfig {
  // API Keys
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseKey => dotenv.env['SUPABASE_KEY'] ?? '';

  // WebSocket
  static String get websocketUrl =>
      dotenv.env['WEBSOCKET_URL'] ?? 'ws://localhost:8000/chat';

  // Validate environment variables are set
  static bool validateEnvVariables() {
    return geminiApiKey.isNotEmpty &&
        supabaseUrl.isNotEmpty &&
        supabaseKey.isNotEmpty;
  }
}
