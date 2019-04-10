import 'package:flutter/material.dart';

import 'package:cup_and_soup/utils/theme.dart';
import 'package:cup_and_soup/pages/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cup&Soup',
      theme: themeUtil.getTheme(),
      home: SplashPage(),
    );
  }
}