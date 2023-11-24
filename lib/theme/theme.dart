import 'package:flutter/material.dart';


ThemeData lightTheme = ThemeData(
fontFamily: 'KdamThmorPro',
brightness: Brightness.light,
colorScheme: const ColorScheme.light(
 background: Colors.white,
 primary: Color.fromARGB(255, 65, 86, 202),
),
primaryTextTheme: const TextTheme(
  displayLarge: TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 65, 86, 202),
  ),
),
 iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 65, 86, 202),
    ),
     textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 214, 214, 214)
    ),
  )
);

ThemeData darkTheme = ThemeData(
  
fontFamily: 'KdamThmorPro',
brightness: Brightness.dark,
colorScheme: const ColorScheme.dark(
 background: Color.fromARGB(255, 27, 27, 27),
 primary: Color.fromARGB(255, 231, 168, 40),
),
primaryTextTheme: const TextTheme(
  displayLarge: TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 231, 168, 40),
  ),
),
 iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 231, 168, 40),
    ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 39, 37, 37)
    ),
  ),
);