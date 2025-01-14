import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themePreferenceKey = 'theme_preference';
  final SharedPreferences _prefs;

  ThemeMode _themeMode;

  ThemeProvider(this._prefs) : _themeMode = _loadThemeMode(_prefs);

  ThemeMode get themeMode => _themeMode;

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final String? themeModeString = prefs.getString(_themePreferenceKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.toString() == themeModeString,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _prefs.setString(_themePreferenceKey, mode.toString());
    notifyListeners();
  }
}
