import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/models/item.dart';

class CloudFirestoreService {
  final Firestore _db = Firestore.instance;
  Map<String, dynamic> _userData = {};

  Future loadUserData() async {
    String uid = authService.getUid();
    var data = await _db.collection('users').document(uid).get();
    var userData = {
      "name": data["name"],
      "money": data["money"],
      "allowdCredit": data["allowedCredit"],
      "role": data["role"],
    };
    return userData;
  }

  Future<Map<String, dynamic>> getUserData() async {
    // print("1" + _userData.toString());
    // if ((_userData == {}) || (_userData == null)) {
    // print("5" + _userData.toString());
       _userData = await loadUserData();
    // }
    return _userData;
  }

  Future<bool> updateItem(Item item) async {
    String uid = authService.getUid();
    if (uid == null) return false;
    await _db
        .collection('items')
        .document(item.id.toString())
        .setData({
      'name': item.name,
      'desc': item.desc,
      'price': item.price,
      'image': item.image,
      'tags': item.tags,
      'stock': item.stock,
      'hechsherim': item.hechsherim
    });
    return true;
  }

  Future<bool> deleteItem(int id) async {
    String uid = authService.getUid();
    if (uid == null) return false;
    await _db
        .collection('items')
        .document(id.toString())
        .delete();
    return true;
  }

}

final CloudFirestoreService cloudFirestoreService = CloudFirestoreService();
