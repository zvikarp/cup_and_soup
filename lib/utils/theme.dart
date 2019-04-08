import 'package:flutter/material.dart';

class ThemeUtil {
  
  /// returns the applications theme.
  ThemeData getTheme() {
    return ThemeData(

      // color theme
      primarySwatch: Colors.yellow,
      primaryColor: Colors.yellow[700],
      accentColor: Colors.grey[900],

    );
  }

}

final ThemeUtil themeUtil = ThemeUtil();