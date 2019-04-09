import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<SharedPreferences> _getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
  
  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await _getInstance();
    String phoneNumber = prefs.getString('phoneNumber');
    return phoneNumber;
  }
  
  Future<bool> setPhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await _getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
    return true;
  }

}

final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();