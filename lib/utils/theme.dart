import 'package:flutter/material.dart';

class ThemeUtil {
  /// returns the applications theme.
  ThemeData getTheme() {
    return ThemeData(
      // color theme
      primaryColor: Color(0xffd8d738),
      accentColor: Color(0xff22211f),

      accentIconTheme: IconThemeData(
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      textTheme: TextTheme(
        body1: TextStyle(
                fontFamily: "PrimaryFont",
                fontSize: 18,
              ),
        body2: TextStyle(
                fontFamily: "PrimaryFont",
                fontSize: 24,
              ),
      )
    );
  }
}

final ThemeUtil themeUtil = ThemeUtil();
