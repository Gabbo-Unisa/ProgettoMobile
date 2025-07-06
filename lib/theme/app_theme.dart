import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF001237),
    scaffoldBackgroundColor: const Color(0xFF000B23),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF000B23),
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      indicatorColor: Colors.lightBlue,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white60,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF000B23),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      bodySmall: TextStyle(color: Colors.white, fontSize: 12),

      labelLarge: TextStyle(color: Colors.white60, fontSize: 16),
      labelMedium: TextStyle(color: Colors.white70, fontSize: 14),
      labelSmall: TextStyle(color: Colors.white70, fontSize: 12),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white60),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white30),
      ),
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.lightBlueAccent,
      selectionHandleColor: Colors.lightBlueAccent,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        return states.contains(MaterialState.selected)
            ? Colors.lightBlueAccent
            : Colors.white24;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        return states.contains(MaterialState.selected)
            ? Colors.lightBlue.withOpacity(0.5)
            : Colors.white10;
      }),
    ),
  );
}
