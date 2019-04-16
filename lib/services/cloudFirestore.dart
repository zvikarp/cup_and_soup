import 'dart:async';
import 'dart:math';

import 'package:rxdart/subjects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/models/item.dart';

class CloudFirestoreService {
  final Firestore _db = Firestore.instance;
  final _requestsStream = PublishSubject();
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

  String generateBarcode(String prefix) {
    DateTime now = DateTime.now();
    String barcode = prefix + (now.minute%10).toString() + now.second.toString() + now.millisecond.toString() +(Random().nextInt(99)).toString();
    return barcode;
  }

  Future<String> uploadBarcode(double amount, String prefix) async {
    String barcode = generateBarcode(prefix);
    var data = await _db.collection('surpriseBox').document(barcode).get();
    if (data.exists) return uploadBarcode(amount, prefix);
    else {
      await _db
        .collection('surpriseBox')
        .document(barcode)
        .setData({
      'type': "money",
      'amount': amount,
      'timestamp': DateTime.now(),
      'author': "a admin",
    });
      return barcode;
    }
  }

  void getRequests() async {
    String uid = await authService.getUid();
    _db.collection('users').document(uid).collection('requests').where('client', isEqualTo: 'app').snapshots().listen((snap) {
      snap.documentChanges.forEach((doc) {
        var request = {
          "rid": doc.document.documentID,
          "barcode": doc.document.data['barcode'],
          "message": doc.document.data['response']['message'],
          "code": doc.document.data['response']['code'],
        };
        _requestsStream.add(request);
      });
    });
  }

  Stream subscribeToRequestsStream() {
    return _requestsStream.stream;
  }

  Future<bool> deleteRequest(int id) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document(id.toString())
        .delete();
    return true;
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

  Future<bool> sendRequest(String barcode) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .add({
      'type': barcode[0],
      'barcode': barcode,
      'client': 'server',
    });
    return true;
  }

}

final CloudFirestoreService cloudFirestoreService = CloudFirestoreService();
