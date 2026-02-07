import 'package:flutter/material.dart';

enum AppTheme {
  light,
  dark,
  sepia;

  String get id => name;

  ThemeData getThemeData({
    required String accentColor,
  }) {
    final Color primaryColor = Color(int.parse('0xFF${accentColor.substring(1)}'));

    switch (this) {
      case AppTheme.light:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: const Color(0xFFffffff),
          cardColor: const Color(0xFFf9fafb),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF1f2937)),
            bodyMedium: TextStyle(color: Color(0xFF1f2937)),
            bodySmall: TextStyle(color: Color(0xFF6b7280)),
            titleLarge: TextStyle(color: Color(0xFF1f2937)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFffffff),
            foregroundColor: Color(0xFF1f2937),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: Color(0xFFe5e7eb)),
            ),
          ),
          dividerColor: const Color(0xFFe5e7eb),
        );
      case AppTheme.dark:
        return ThemeData(
          brightness: Brightness.dark,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: const Color(0xFF111827),
          cardColor: const Color(0xFF1f2937),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFf9fafb)),
            bodyMedium: TextStyle(color: Color(0xFFf9fafb)),
            bodySmall: TextStyle(color: Color(0xFF9ca3af)),
            titleLarge: TextStyle(color: Color(0xFFf9fafb)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF111827),
            foregroundColor: Color(0xFFf9fafb),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: Color(0xFF374151)),
            ),
          ),
          dividerColor: const Color(0xFF374151),
        );
      case AppTheme.sepia:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: const Color(0xFFf4ecd8),
          cardColor: const Color(0xFFeaddca),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF5d4037)),
            bodyMedium: TextStyle(color: Color(0xFF5d4037)),
            bodySmall: TextStyle(color: Color(0xFF8d6e63)),
            titleLarge: TextStyle(color: Color(0xFF5d4037)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFf4ecd8),
            foregroundColor: Color(0xFF5d4037),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: Color(0xFFd7ccc8)),
            ),
          ),
          dividerColor: const Color(0xFFd7ccc8),
        );
    }
  }
}
