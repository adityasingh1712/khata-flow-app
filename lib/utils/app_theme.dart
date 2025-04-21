import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.teal[700], // Primary brand color
    scaffoldBackgroundColor:
        const Color(0xFFF8F9FA), // Light neutral background
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal[700],
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.teal[700],
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.teal[700]!,
      secondary: Colors.green[400]!, // Credit color (green)
      error: Colors.red[400]!, // Debit color (red)
      background: const Color(0xFFF8F9FA),
      surface: Colors.white, // Cards and surfaces
      onPrimary: Colors.white, // Text on primary color
      onSecondary: Colors.white, // Text on secondary color
      onError: Colors.white, // Text on error color
      onSurface: Colors.black87, // Text on surface color
      onBackground: Colors.black87, // Text on background
    ),
    dividerColor: Colors.grey.shade300,
    iconTheme: const IconThemeData(color: Colors.black87),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.teal[700], // Button primary color
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[700], // Elevated button background color
        foregroundColor: Colors.white, // Text color on elevated button
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.teal[700], // TextButton color
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[700]!),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[700]!),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[700]!),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal[300],
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal[300],
      foregroundColor: Colors.black,
      elevation: 2,
    ),
    cardColor: const Color(0xFF1E1E1E), // Dark card color
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.teal[300],
      foregroundColor: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.teal[300]!,
      secondary: Colors.green[300]!, // Credit color (green)
      error: Colors.red[300]!, // Debit color (red)
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E), // Dark surfaces
      onPrimary: Colors.black, // Text on primary color
      onSecondary: Colors.black, // Text on secondary color
      onError: Colors.white, // Text on error color
      onSurface: Colors.white, // Text on surface
      onBackground: Colors.white, // Text on background
    ),
    dividerColor: Colors.grey.shade700,
    iconTheme: const IconThemeData(color: Colors.white),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.teal[300], // Button primary color
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[300], // Elevated button background color
        foregroundColor: Colors.black, // Text color on elevated button
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.teal[300], // TextButton color
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E), // Dark input field background
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
