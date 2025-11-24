import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier to manage theme mode with persistence (Riverpod 3.x)
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _themeModeKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  /// Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    final savedThemeMode = await asyncPrefs.getString(_themeModeKey);

    if (savedThemeMode != null) {

      state = _stringToThemeMode(savedThemeMode);
    }
  }

  /// Update theme mode and persist to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setString(_themeModeKey, _themeModeToString(mode));
  }

  /// Convert ThemeMode to String for persistence
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  /// Convert String to ThemeMode
  ThemeMode _stringToThemeMode(String modeString) {
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

/// Provider for theme mode (Riverpod 3.x syntax)
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});
