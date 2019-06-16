import 'package:flutter/material.dart';

class LightTheme {
  Map<dynamic, dynamic> _theme = {

    // app colors
    "primaryColor": Color(0xffd8d738),
    "accentColor": Color(0xff000000),
    "canvasColor": Colors.white,
    "disabled": Colors.grey[300],

    // core widgets colors
    "dividerColor": Colors.black,
    "tableColor": Colors.grey[200],
    "centerColor": Colors.black,
    "cardColor": Colors.grey[200],
    "dialogColor": Colors.white,
    "dialogShadowColor": Color(0xfff9E9E9E),
    "dialogBlurColor": Color(0x10ffffff),

    // text colors
    "headline": Colors.white,
    "title": Colors.black,
    "subtitle": Colors.black54,
    "display1": Colors.black,
    "body1": Colors.black54,
    "body2": Colors.black,
    "button": Colors.black,
    "caption": Colors.black54,
  };

  get theme => _theme;
}

final LightTheme lightTheme = LightTheme();
