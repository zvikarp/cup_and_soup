import 'package:flutter/material.dart';

class DarkTheme {
  Map<dynamic, dynamic> _theme = {

    // app colors
    "primaryColor": Color(0xffd8c440),
    "accentColor": Color(0xffaaaaaa),
    "canvasColor": Color(0xff1e1e1e),
    "disabled": Color(0xff3a3d41),

    // core widgets colors
    "dividerColor": Colors.white,
    "tableColor": Color(0xff3a3d41),
    "centerColor": Color(0xff3a3d41),
    "cardColor": Colors.grey[400],
    "dialogColor": Colors.grey[400],
    "dialogShadowColor": Color(0x6a000000),
    "dialogBlurColor": Color(0x10000000),

    // text colors
    "headline": Colors.white,
    "title": Colors.white,
    "subtitle": Color(0xffaaaaaa),
    "display1": Color(0xffaaaaaa),
    "body1": Color(0xffaaaaaa),
    "body2": Color(0xffaaaaaa),
    "button": Colors.black,
    "caption": Color(0xffaaaaaa),
  };

  get theme => _theme;
}

final DarkTheme darkTheme = DarkTheme();
