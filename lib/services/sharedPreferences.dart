import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> _getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
  
  Future<String> getLang() async {
    SharedPreferences prefs = await _getInstance();
    String lang = prefs.getString('lang');
    return lang;
  }
  
  Future<bool> setLang(String lang) async {
    SharedPreferences prefs = await _getInstance();
    await prefs.setString('lang', lang);
    return true;
  }
  
  Future<String> getTheme() async {
    SharedPreferences prefs = await _getInstance();
    String theme = prefs.getString('theme');
    return theme;
  }
  
  Future<bool> setTheme(String theme) async {
    SharedPreferences prefs = await _getInstance();
    await prefs.setString('theme', theme);
    return true;
  }
  
  Future<List<String>> getRoles() async {
    SharedPreferences prefs = await _getInstance();
    List<String> roles = prefs.getStringList('roles');
    return roles;
  }
  
  Future<bool> setRoles(List<String> roles) async {
    SharedPreferences prefs = await _getInstance();
    await prefs.setStringList('roles', roles);
    return true;
  }

}

final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();