import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> _getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
  
  Future<String> getLang() async {
    SharedPreferences prefs = await _getInstance();
    String lang = prefs.getString('lang');
    print("---------------------------------------5555555555-------" + lang);
    return lang;
  }
  
  Future<bool> setLang(String lang) async {
    SharedPreferences prefs = await _getInstance();
    await prefs.setString('lang', lang);
    return true;
  }

}

final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();