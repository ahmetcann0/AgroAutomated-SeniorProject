import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    //primaryColor: const Color(0xFF159148), // LOGO GREEN
    primaryColor: const Color(0xFF0D986A), // BUTTON GREEN
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey[100], // WHITE
    dialogBackgroundColor: Colors.grey[100],
    hintColor: const Color(0xFFD9D9D9), // LOGO GREEN
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF12121D)),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
  );

  static final darkTheme = ThemeData(
    // primaryColor: const Color(0xFF159148), // LOGO GREEN
    primaryColor: const Color(0xFF0D986A), // BUTTON GREEN
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[800],
    dialogBackgroundColor: Colors.grey[900],
    hintColor: const Color(0xFFD9D9D9),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
  );
}
