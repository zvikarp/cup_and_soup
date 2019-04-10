import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/services/sharedPreferences.dart';

class CloudFirestoreService {
  final Firestore _db = Firestore.instance;
  Map<String, dynamic> _userData = {};

  Future loadUserData() async {
    String uid = authService.getUid();
    var data = await _db.collection('users').document(uid).get();
    _userData = {
      "name": data["name"],
      "money": data["money"],
      "allowdCredit": data["allowedCredit"],
      "role": data["role"],
    };
  }

  Future<Map<String, dynamic>> getUserData() async {
    if (_userData == {}) await loadUserData();
    return _userData;
  }
}

final CloudFirestoreService cloudFirestoreService = CloudFirestoreService();
