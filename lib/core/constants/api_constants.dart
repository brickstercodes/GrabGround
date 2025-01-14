import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {
  // Base URLs
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String turfListEndpoint = '/turfs';
  static const String bookingEndpoint = '/bookings';

  // API Versions
  static const String apiVersion = 'v1';

  // Timeouts
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Headers
  static const String authHeader = 'Authorization';
  static const String contentType = 'application/json';

  // Chat AI Configuration
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get geminiModel =>
      dotenv.env['GEMINI_MODEL'] ?? 'gemini-pro-vision';
  static const int maxOutputTokens = 2048;
  static const double temperature = 0.9;
  static const int topK = 40;
  static const double topP = 0.95;
}
