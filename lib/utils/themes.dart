import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cup_and_soup/data/theme/light.dart';
import 'package:cup_and_soup/data/theme/dark.dart';

import 'package:cup_and_soup/services/sharedPreferences.dart';

Map<String, dynamic> _supportedThemes = {
  'light': lightTheme.theme,
  'dark': darkTheme.theme
};

class ThemeUtil {
  String _theme;
  Map<dynamic, dynamic> _themedValues;
  VoidCallback _onThemeChangedCallback;

  Iterable<String> supportedThemes() => _supportedThemes.keys;

  dynamic load(String key) {
    return (_themedValues == null || _themedValues[key] == null)
        ? '** $key not found'
        : _themedValues[key];
  }

  get theme => _theme;

  Future<Null> init([String theme]) async {
    if (_theme == null) {
      await setNewTheme(theme);
    }
    return null;
  }

  Future<String> getPreferredTheme() async {
    return await sharedPreferencesService.getTheme() ?? 'light';
  }

  setPreferredTheme(String theme) async {
    return await sharedPreferencesService.setTheme(theme);
  }

  Future<Null> setNewTheme([String newTheme, bool saveInPrefs = true]) async {
    String theme = newTheme;
    if (theme == null) {
      theme = await getPreferredTheme();
    }
    if (theme == "") {
      theme = "light";
    }
    _theme = theme;
    _themedValues = _supportedThemes[_theme];
    if (saveInPrefs) {
      await setPreferredTheme(theme);
    }
    if (_onThemeChangedCallback != null) {
      _onThemeChangedCallback();
    }
    return null;
  }

  set onThemeChangedCallback(VoidCallback callback) {
    _onThemeChangedCallback = callback;
  }

  static final ThemeUtil _themes = new ThemeUtil._internal();
  factory ThemeUtil() {
    return _themes;
  }
  ThemeUtil._internal();
}

ThemeUtil themes = new ThemeUtil();
