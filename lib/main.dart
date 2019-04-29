import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:cup_and_soup/services/sharedPreferences.dart';
import 'package:cup_and_soup/utils/theme.dart';
import 'package:cup_and_soup/pages/splash.dart';
import 'package:cup_and_soup/utils/localizations.dart';

void main() {
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
  bool localeLoaded = false;
  List<Locale> locales = [
    const Locale('he', 'IL'),
    const Locale('en', 'US'),
  ];

  @override
  void initState() {
    super.initState();
    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this._locale = locale;
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.localeLoaded == false) {
      return MaterialApp(home: Scaffold());
    } else {
      return MaterialApp(
        title: 'cup&soup',
        theme: themeUtil.getTheme(),
        home: SplashPage(),
        supportedLocales: locales,
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

  _fetchLocale() async {
    String lang = await sharedPreferencesService.getLang() ?? 'en';
    for (var l in locales) {
      if (lang == l.languageCode) return l;
    }
    return locales.first;
  }
}
