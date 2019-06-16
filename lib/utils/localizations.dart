import 'dart:async';
import 'dart:ui';

import 'package:cup_and_soup/services/sharedPreferences.dart';
import 'package:cup_and_soup/data/lang/en.dart';
import 'package:cup_and_soup/data/lang/he.dart';

Map<String, dynamic> _supportedLanguages = {
  'en': enLang.lang,
  'he': heLang.lang
};

class TranslationsUtil {
  Locale _locale;
  Map<String, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;

  Iterable<Locale> supportedLocales() =>
      _supportedLanguages.keys.map<Locale>((lang) => new Locale(lang, ''));

  dynamic text(String key) {
    return (_localizedValues == null || _localizedValues[key] == null)
        ? '** $key not found'
        : _localizedValues[key];
  }

  bool rtl() => _locale.languageCode == 'he';

  get currentLanguage => _locale == null ? '' : _locale.languageCode;

  get locale => _locale;

  Future<Null> init([String language]) async {
    if (_locale == null) {
      await setNewLanguage(language);
    }
    return null;
  }

  Future<String> getPreferredLanguage() async {
    String lang = await sharedPreferencesService.getLang() ?? 'en';
    if (!_supportedLanguages.keys.contains(lang)) lang = 'en';
    return lang;
  }

  setPreferredLanguage(String lang) async {
    return await sharedPreferencesService.setLang(lang);
  }

  Future<Null> setNewLanguage(
      [String newLanguage, bool saveInPrefs = true]) async {
    String language = newLanguage;
    if (language == null) {
      language = await getPreferredLanguage();
    }
    if (language == "") {
      language = "en";
    }
    _locale = Locale(language, "");
    _localizedValues = _supportedLanguages[_locale.languageCode];
    if (saveInPrefs) {
      await setPreferredLanguage(language);
    }
    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback();
    }
    return null;
  }

  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  static final TranslationsUtil _translations =
      new TranslationsUtil._internal();
  factory TranslationsUtil() {
    return _translations;
  }
  TranslationsUtil._internal();
}

TranslationsUtil translate = new TranslationsUtil();
