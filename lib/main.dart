import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:cup_and_soup/utils/themes.dart';
import 'package:cup_and_soup/pages/splash.dart';
import 'package:cup_and_soup/utils/localizations.dart';
import 'package:cup_and_soup/data/theme/app.dart';

void main() async {
  Crashlytics.instance.enableInDevMode = false;

  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.onError(details);
  };

  await translate.init();
  await themes.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(App());
  });
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Locale _locale = translate.locale;
  String _theme = themes.theme;

  @override
  void initState() {
    super.initState();
    translate.onLocaleChangedCallback = _onLocaleChanged;
    themes.onThemeChangedCallback = _onThemeChanged;
    setState(() {
      _locale = translate.locale;
    });
  }

  _onLocaleChanged() async {
    setState(() {
      _locale = translate.locale;
    });
  }

  _onThemeChanged() async {
    setState(() {
      _theme = themes.theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cup&soup',
      theme: appTheme.getThemeData(_theme),
      home: SplashPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: translate.supportedLocales(),
    );
  }
}
