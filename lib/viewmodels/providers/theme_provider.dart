import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/constants.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;

  ThemeProvider() {
    // Initialize theme based on system preference
    final window = WidgetsBinding.instance.window;
    _isDarkMode = window.platformBrightness == Brightness.dark;
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _updateSystemUI();
    notifyListeners();
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
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
