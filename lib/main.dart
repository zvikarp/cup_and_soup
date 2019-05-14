import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:cup_and_soup/utils/theme.dart';
import 'package:cup_and_soup/pages/splash.dart';
import 'package:cup_and_soup/utils/localizations.dart';

void main() {
  Crashlytics.instance.enableInDevMode = false;

  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.onError(details);
  };

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
  Locale _locale;
  ThemeData _theme;
  bool _localeLoaded = false;
  bool _themeLoaded = false;

  void listenToLocaleChange() {
    Stream<Locale> _localeStream = localizationsUtil.streamLocale();
    _localeStream.listen((Locale locale) {
      setState(() {
       _locale = locale;
      });
    });
  }

  void listenToThemeChange() {
    Stream<ThemeData> _themeStream = themeUtil.streamTheme();
    _themeStream.listen((ThemeData theme) {
      setState(() {
       _theme = theme;
      });
    });
  }

  void getLocale() async {
    Locale locale = await localizationsUtil.getLocale();
    setState(() {
     _locale = locale; 
      _localeLoaded = true;
    });
  }

  void getTheme() async {
    ThemeData theme = await themeUtil.getTheme();
    setState(() {
     _theme = theme;
  _themeLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocale();
    getTheme();
    listenToLocaleChange();
    listenToThemeChange();
  }

  @override
  Widget build(BuildContext context) {
    if ((_localeLoaded == false) || (_themeLoaded == false)) {
      return MaterialApp(home: Scaffold());
    } else {
      return MaterialApp(
        title: 'cup&soup',
        theme: _theme,
        home: SplashPage(),
        supportedLocales: localizationsUtil.getLocalesList(),
        locale: _locale,
        localizationsDelegates: [
          LanguageDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          return _locale;
        },
      );
    }
  }
}
