import 'dart:convert';

import 'package:cup_and_soup/models/user.dart';
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

  Future<Map<String, dynamic>> getDiscount() async {
    SharedPreferences prefs = await _getInstance();
    String discount = prefs.getString('discount');
    return json.decode(discount) ?? {};
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

  Future<List<String>> getNtifications() async {
    SharedPreferences prefs = await _getInstance();
    List<String> notifications = prefs.getStringList('notifications');
    return notifications;
  }

  Future<bool> setNotifications(List<String> notifications) async {
    SharedPreferences prefs = await _getInstance();
    await prefs.setStringList('notifications', notifications);
    return true;
  }

  Future<bool> setFcmToken(String fcmToken) async {
    SharedPreferences prefs = await _getInstance();
    await prefs.setString('fcmToken', fcmToken);
    return true;
  }

  Future<String> getFcmToken() async {
    SharedPreferences prefs = await _getInstance();
    String fcmToken = prefs.getString('fcmToken');
    return fcmToken;
  }

  Future<bool> updatedUserDetailes(User user) async {
    SharedPreferences prefs = await _getInstance();
    await prefs.setString('uid', user.uid);
    await prefs.setString('name', user.name);
    await prefs.setDouble('money', user.money);
    await prefs.setDouble('allowedCredit', user.allowedCredit);
    await prefs.setString('email', user.email);
    await prefs.setBool('disabled', user.disabled);
    await prefs.setStringList('roles', user.roles);
    await prefs.setString('discount', json.encode(user.discount));
    await prefs.setString('fcmToken', user.fcmToken);
    await prefs.setStringList('notifications', user.notifications);
    return true;
  }

  Future<User> getUserDetailes() async {
    SharedPreferences prefs = await _getInstance();
    User user = User();
    user.uid = prefs.getString('uid') ?? User.defaultUser().uid;
    user.name = prefs.getString('name') ?? User.defaultUser().name;
    user.money = prefs.getDouble('money') ?? User.defaultUser().money;
    user.email = prefs.getString('email') ?? User.defaultUser().email;
    user.allowedCredit = prefs.getDouble('allowedCredit') ?? User.defaultUser().allowedCredit;
    user.disabled = prefs.getBool('disabled') ?? User.defaultUser().disabled;
    user.roles = prefs.getStringList('roles') ?? User.defaultUser().roles;
    user.discount = json.decode(prefs.getString('discount') ?? json.encode(User.defaultUser().discount)) ?? User.defaultUser().discount;
    user.fcmToken = prefs.getString('fcmTocken') ?? User.defaultUser().fcmToken;
    user.notifications = prefs.getStringList('notifications') ?? User.defaultUser().notifications;
    return user;
  }
}

final SharedPreferencesService sharedPreferencesService =
    SharedPreferencesService();
