import 'package:flutter/material.dart';

class ThemeUtil {
  ThemeData _lightTheme = ThemeData(
    primaryColor: Color(0xffd8d738),
    accentColor: Color(0xff000000),
    accentIconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(

      headline: TextStyle(fontFamily: "BrandFont",   fontSize: 65),
      title:    TextStyle(fontFamily: "PrimaryFont", fontSize: 24),
      subtitle: TextStyle(fontFamily: "PrimaryFont", fontSize: 16, color: Colors.black54),
      display1: TextStyle(fontFamily: "PrimaryFont", fontSize: 34),
      body1:    TextStyle(fontFamily: "PrimaryFont", fontSize: 18),
      body2:    TextStyle(fontFamily: "PrimaryFont", fontSize: 18, fontWeight: FontWeight.bold),
      button:   TextStyle(fontFamily: "PrimaryFont", fontSize: 14, fontWeight: FontWeight.bold),
      caption:  TextStyle(fontFamily: "PrimaryFont", fontSize: 12, color: Colors.black54),

    ),
  );

  ThemeData _darkTheme = ThemeData(
      primaryColor: Color(0xffd8d738),
      accentColor: Color(0xff000000),
      accentIconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        body1: TextStyle(fontFamily: "PrimaryFont", fontSize: 18),
        body2: TextStyle(fontFamily: "PrimaryFont", fontSize: 24),
      ));

  ThemeData getTheme([bool dark=false]) {
    if (!dark)
      return _lightTheme;
    else
      return _darkTheme;
  }
}

final ThemeUtil themeUtil = ThemeUtil();
