import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  ThemeMode get currentThemeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppConstants.voltisDark,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppConstants.voltisLight,
      secondary: AppConstants.voltisAccent,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppConstants.voltisLight,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppConstants.voltisDark,
      secondary: AppConstants.voltisAccent,
    ),
  );
}
