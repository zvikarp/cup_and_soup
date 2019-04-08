import 'package:flutter/material.dart';

import 'package:cup_and_soup/utils/theme.dart';
import 'package:cup_and_soup/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeUtil.getTheme(),
      home: HomePage(),
    );
  }
}