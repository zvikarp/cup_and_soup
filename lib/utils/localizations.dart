import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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