import 'package:cup_and_soup/services/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:cup_and_soup/models/appTheme.dart';

class ThemeWidget extends InheritedWidget {
  ThemeWidget({
    Widget child,
    this.theme,
  }) : super(child: child);

  final AppTheme theme;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ThemeWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ThemeWidget);
}

class ThemeUtil {
  Map<String, AppTheme> _themes = {
    "light": AppTheme(
      colorXYZ: Colors.blue,
      materialTheme: ThemeData(
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
    ),
    "dark": AppTheme(
      colorXYZ: Colors.red,
      materialTheme: ThemeData(
        canvasColor: Colors.grey[800],
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
    ),
  };

  BehaviorSubject<AppTheme> _themeStream = BehaviorSubject();
  AppTheme _theme;

  Stream streamTheme() {
    if (_themeStream == null) updateStreamTheme(_theme);
    return _themeStream.stream;
  }

  Future<AppTheme> getTheme() async {
    String code = await sharedPreferencesService.getTheme() ?? 'light';
    AppTheme theme = codeToTheme(code);
    _theme = theme;
    return _theme;
  }

  Map<String, AppTheme> getThemesList() => _themes;

  Future<bool> setTheme(AppTheme theme) async {
    _theme = theme;
    await sharedPreferencesService.setTheme(themeToCode(theme));
    updateStreamTheme(_theme);
    return true;
  }

  void updateStreamTheme(AppTheme theme) {
    _themeStream.add(_theme);
  }

  AppTheme codeToTheme(String code) {
    for (var t in _themes.keys) {
      if (code == t) return _themes[t];
    }
    return _themes['light'];
  }

  String themeToCode(AppTheme theme) {
    for (var t in _themes.keys) {
      if (theme == _themes[t]) return t;
    }
    return 'light';
  }
}

final ThemeUtil themeUtil = ThemeUtil();
