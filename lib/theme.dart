
import 'package:flutter/material.dart';

ThemeData buildTheme() {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
          ),
        ),
      ),
        // brightness: Brightness.light,
        // primaryColor: Colors.white,
        // accentColor: Colors.white,
        // scaffoldBackgroundColor: Colors.white,
        // textSelectionHandleColor: Colors.black,
        // textSelectionColor: Colors.black12,
        // cursorColor: Colors.black,
        // toggleableActiveColor: Colors.black,
        // inputDecorationTheme: InputDecorationTheme(
        //     border: const OutlineInputBorder(
        //         borderSide: BorderSide(color: Colors.black),
        //     ),
        //     enabledBorder: OutlineInputBorder(
        //         borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
        //     ),
        //     focusedBorder: const OutlineInputBorder(
        //         borderSide: BorderSide(color: Colors.black),
        //     ),
        //     labelStyle: const TextStyle(
        //         color: Colors.black,
        //     ),
        // ),
    );
}