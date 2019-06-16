import 'package:cup_and_soup/utils/localizations.dart';
import 'package:flutter/material.dart';
import 'package:cup_and_soup/utils/themes.dart';

class AppTheme {
  getThemeData(String theme) {
    return ThemeData(
      canvasColor: themes.load("canvasColor"),
      primaryColor: themes.load("primaryColor"),
      accentColor: themes.load("accentColor"),
      cardColor: themes.load("cardColor"),
      cursorColor: themes.load("primaryColor"),
      dialogBackgroundColor: themes.load("dialogColor"),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: themes.load("body1")),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: themes.load("body1")),
        ),
      ),
      textTheme: TextTheme(
        headline: TextStyle(
            fontFamily: translate.rtl() ? "HeBrandFont" : "BrandFont",
            fontSize: 65,
            color: themes.load("headline")),
        title: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
            color: themes.load("title")),
        subtitle: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 16,
            color: themes.load("subtitle")),
        display1: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 34,
            color: themes.load("display1")),
        body1: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
            color: themes.load("body1")),
        body2: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themes.load("body2")),
        button: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: themes.load("button")),
        caption: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 12,
            color: themes.load("caption")),
      ),
    );
  }
}

final AppTheme appTheme = AppTheme();
