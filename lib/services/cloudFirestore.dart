import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/models/item.dart';

class CloudFirestoreService {
  final Firestore _db = Firestore.instance;
  Map<String, dynamic> _userData;

  Future<String> getRole() async {
    if (_userData != null) {
      print("1 user role is" + _userData['role']);
      return _userData['role'];
    } else {
      await loadUserData();
      if (_userData != null)
        return _userData['role'];
      else
        return null;
    }
  }

  Future loadUserData() async {
    String uid = await authService.getUid();
    var data = await _db.collection('users').document(uid).get();
    var userData = {
      "name": data["name"],
      "money": data["money"],
      "allowdCredit": data["allowedCredit"],
      "role": data["role"],
    };
    _userData = userData;
    return userData;
  }

  Future<bool> updateItem(Item item) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    await _db
        .collection('store')
        .document(item.barcode.toString())
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
    String uid = await authService.getUid();
    if (uid == null) return false;
    await _db
        .collection('store')
        .document(id.toString())
        .delete();
    return true;
  }

  Future<bool> buyItem(String barcode) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .add({
      'type': 'buy',
      'barcode': barcode,
      'client': 'server',
    });
    return true;
  }

}

final CloudFirestoreService cloudFirestoreService = CloudFirestoreService();
