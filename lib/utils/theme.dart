import 'package:cup_and_soup/services/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ThemeUtil {
  Map<String, ThemeData> _themes = {
    "light": ThemeData(
      canvasColor: Colors.white,
      primaryColor: Color(0xffd8d738),
      accentColor: Color(0xff000000),
      accentIconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        headline: TextStyle(fontFamily: "BrandFont", fontSize: 65),
        title: TextStyle(fontFamily: "PrimaryFont", fontSize: 24),
        subtitle: TextStyle(
            fontFamily: "PrimaryFont", fontSize: 16, color: Colors.black54),
        display1: TextStyle(fontFamily: "PrimaryFont", fontSize: 34),
        body1: TextStyle(fontFamily: "PrimaryFont", fontSize: 18),
        body2: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
            fontWeight: FontWeight.bold),
        button: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 14,
            fontWeight: FontWeight.bold),
        caption: TextStyle(
            fontFamily: "PrimaryFont", fontSize: 12, color: Colors.black54),
      ),
    ),
    "dark": ThemeData(
      canvasColor: Colors.black87,
      primaryColor: Color(0xffd8d738),
      accentColor: Color(0xff000000),
      accentIconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        body1: TextStyle(fontFamily: "PrimaryFont", fontSize: 18),
        body2: TextStyle(fontFamily: "PrimaryFont", fontSize: 24),
      ),
    ),
  };

  BehaviorSubject<ThemeData> _themeStream = BehaviorSubject();
  ThemeData _theme;

  Stream streamTheme() {
    if (_themeStream == null) updateStreamTheme(_theme);
    return _themeStream.stream;
  }

  Future<ThemeData> getTheme() async {
    String code = await sharedPreferencesService.getTheme() ?? 'light';
    ThemeData theme = codeToTheme(code);
    _theme = theme;
    return _theme;
  }

  Map<String, ThemeData> getThemesList() => _themes;

  Future<bool> setTheme(ThemeData theme) async {
    _theme = theme;
    await sharedPreferencesService.setTheme(themeToCode(theme));
    updateStreamTheme(_theme);
    return true;
  }

  void updateStreamTheme(ThemeData theme) {
    _themeStream.add(_theme);
  }

  ThemeData codeToTheme(String code) {
    for (var t in _themes.keys) {
      if (code == t) return _themes[t];
    }
    return _themes['light'];
  }

  String themeToCode(ThemeData theme) {
    for (var t in _themes.keys) {
      if (theme == _themes[t]) return t;
    }
    return 'light';
  }

}

final ThemeUtil themeUtil = ThemeUtil();
