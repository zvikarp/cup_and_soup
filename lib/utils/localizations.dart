import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

import 'package:cup_and_soup/services/sharedPreferences.dart';

class Language {
  Language(this.locale);  
  
  final Locale locale;  
  
  static Language of(BuildContext context) {  
    return Localizations.of<Language>(context, Language);  
  }  
  
  Map<String, String> _sentences;
  
  Future<bool> load() async {
    String data = await rootBundle.loadString('resources/lang/${this.locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }
  
  String translate(String key) {  
    return this._sentences[key];  
  }  
}

class LanguageDelegate extends LocalizationsDelegate<Language> {  
  const LanguageDelegate();  
  
  @override  
  bool isSupported(Locale locale) => ['en', 'he'].contains(locale.languageCode);  
  
  @override  
  Future<Language> load(Locale locale) async {
    Language localizations = Language(locale);  
  await localizations.load();  
  
  print("Load ${locale.languageCode}");  
  
  return localizations;
  }
  
  @override  
  bool shouldReload(LanguageDelegate old) => false;  
}

class LocalizationsUtil {

  BehaviorSubject<Locale> _localeStream = BehaviorSubject();
  Locale _locale = Locale('en', 'US');
  List<Locale> _locales = [
    const Locale('he', 'IL'),
    const Locale('en', 'US'),
  ];

  Stream streamLocale() {
    if (_localeStream == null) updateStreamLocale(_locale);
    return _localeStream.stream;
  }

  Future<Locale> getLocale() async {
    String code = await sharedPreferencesService.getLang() ?? 'en';
    Locale locale = codeToLocale(code);
    _locale = locale;
    return _locale;
  }

  List<Locale> getLocalesList() => _locales;

  Future<bool> setLocal(Locale locale) async {
    _locale = locale;
    await sharedPreferencesService.setLang(localeToCode(locale));
    updateStreamLocale(_locale);
    return true;
  }

  void updateStreamLocale(Locale locale) {
    _localeStream.add(_locale);
  }

  Locale codeToLocale(String code) {
    for (var l in _locales) {
      if (code == l.languageCode) return l;
    }
    return _locales.first;
  }

  String localeToCode(Locale locale) {
    for (var l in _locales) {
      if (locale == l) return l.languageCode;
    }
    return _locales.first.languageCode;
  } 

}

final LocalizationsUtil localizationsUtil = LocalizationsUtil();