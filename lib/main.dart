import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cup_and_soup/utils/theme.dart';
import 'package:cup_and_soup/pages/splash.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(App());
  });
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cup&soup',
      theme: themeUtil.getTheme(),
      home: SplashPage(),
    );
  }
}
