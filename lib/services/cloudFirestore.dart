import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cup_and_soup/services/firebaseStorage.dart';
import 'package:rxdart/subjects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/models/item.dart';

class CloudFirestoreService {
  final Firestore _db = Firestore.instance;
  final _buyRequestsStream = PublishSubject();
  final _moneyRequestsStream = PublishSubject();
  Map<String, dynamic> _userData;
  List<dynamic> _activityList = [];

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
    String barcode = prefix +
        (now.minute % 10).toString() +
        now.second.toString() +
        now.millisecond.toString() +
        (Random().nextInt(99)).toString();
    return barcode;
  }

  Future<String> uploadMoneyBarcode(
      double amount, bool userLimit, int quantity) async {
    String barcode = generateBarcode("M");
    var data = await _db.collection('surpriseBox').document(barcode).get();
    if (data.exists)
      return uploadMoneyBarcode(amount, userLimit, quantity);
    else {
      await _db.collection('surpriseBox').document(barcode).setData({
        'type': "money",
        'amount': amount,
        'expiringDate': DateTime.now().add(Duration(minutes: 5)),
        'userLimit': userLimit,
        'quantity': quantity,
      });
      return barcode;
    }
  }

  void getRequests() async {
    String uid = await authService.getUid();
    _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('buy')
        .snapshots()
        .listen((snap) {
      if (snap.exists) {
        var request = {
          "barcode": snap.data['barcode'],
          "message": snap.data['response']['message'],
          "code": snap.data['response']['code'],
        };
        _buyRequestsStream.add(request);
      }
    });
    _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('money')
        .snapshots()
        .listen((snap) {
      if (snap.exists) {
        var request = {
          "barcode": snap.data['barcode'],
          "message": snap.data['response']['message'],
          "code": snap.data['response']['code'],
        };
        _moneyRequestsStream.add(request);
      }
    });
  }

  Stream subscribeToBuyRequestsStream() {
    return _buyRequestsStream.stream;
  }

  Stream subscribeToMoneyRequestsStream() {
    return _moneyRequestsStream.stream;
  }

  Future<bool> deleteRequest(String type) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document(type)
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
      "email": data["email"],
    };
    _userData = userData;
    return userData;
  }

  Future<String> updateItem(Item item,
      [File image, String imageState, String oldBarcode = ""]) async {
    String uid = await authService.getUid();
    if (uid == null)
      return "Can't connect to your account, try restarting the app.";
    String imageUrl = item.image;
    if (oldBarcode != item.barcode) {
      var doc =
          await _db.collection('store').document(item.barcode.toString()).get();
      if (doc.exists) {
        return "This barcode already exists, the barcode needs to be unique.";
      }
    }
    if (imageState == "deleted") {
      await firebaseStorageService.deleteImage(imageUrl);
      imageUrl = "no image";
    } else if (imageState == "added") {
      imageUrl = await firebaseStorageService.uploadImage(image, item.barcode);
    } else if (imageState == "changed") {
      await firebaseStorageService.deleteImage(imageUrl);
      imageUrl = await firebaseStorageService.uploadImage(image, item.barcode);
    }
    await _db.collection('store').document(item.barcode.toString()).setData({
      'name': item.name,
      'desc': item.desc,
      'price': item.price,
      'image': imageUrl,
      'tags': item.tags,
      'stock': item.stock,
      'hechsherim': item.hechsherim
    });
    return "ok";
  }

  Future<bool> deleteItem(String id) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    await _db.collection('store').document(id.toString()).delete();
    return true;
  }

  Future<bool> buyItem(String barcode) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    var doc = await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('buy')
        .get();
    if (doc.exists) {
      DateTime expiringDate = doc.data['expiringDate'].toDate();
      if (DateTime.now().millisecondsSinceEpoch >
          expiringDate.millisecondsSinceEpoch) {
        await _db
            .collection('users')
            .document(uid)
            .collection('requests')
            .document('buy')
            .delete();
      } else {
        return false;
      }
    }
    await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('buy')
        .setData({
      'barcode': barcode,
      'client': 'server',
      'expiringDate': DateTime.now().add(Duration(minutes: 1)),
    });
    return true;
  }

  Future<bool> sendMoneyRequest(String barcode) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    var doc = await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('money')
        .get();
    if (doc.exists) {
      DateTime expiringDate = doc.data['expiringDate'].toDate();
      if (DateTime.now().millisecondsSinceEpoch >
          expiringDate.millisecondsSinceEpoch) {
        await _db
            .collection('users')
            .document(uid)
            .collection('requests')
            .document('money')
            .delete();
      } else {
        return false;
      }
    }
    await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('money')
        .setData({
      'barcode': barcode,
      'client': 'server',
      'expiringDate': DateTime.now().add(Duration(minutes: 1)),
    });
    return true;
  }

  void clearSupriseBox() async {
    _db
        .collection('surpriseBox')
        .where('expiringDate', isLessThan: DateTime.now())
        .getDocuments()
        .then((snapshot) {
      for (var doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  Future<int> getActivityItemsCount() async {
    String uid = await authService.getUid();
    if (uid == null) return 0;
    int length = 0;
    await _db
        .collection('users')
        .document(uid)
        .collection('activity')
        // .orderBy('__name__', descending: true)
        .limit(1)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((doc) {
        length = doc.data['counter'] + (100 * int.parse(doc.documentID));
      });
    });
    return length;
  }

  Future<List<dynamic>> getActivityItems(int first, int last) async {
    String uid = await authService.getUid();
    _activityList
        .sort((b, a) => a['timestamp'].compareTo(b['timestamp']));
    if (_activityList.length < last) {
      if (((_activityList.length - 1) - first) > 0)
        _activityList.removeRange(first, _activityList.length - 1);
      var doc = await _db
          .collection('users')
          .document(uid)
          .collection('activity')
          .document(((_activityList.length + 1) ~/ 100).toInt().toString())
          .get();
      print(((_activityList.length + 1) ~/ 100).toInt());
      doc.data['activities'].forEach((k, v) {
        Map data = {
          'timestamp': v['timestamp'],
          'desc': v['desc'],
          'money': v['money'],
          'type': v['type'],
        };
        _activityList.add(data);
      });
      _activityList
          .sort((b, a) => a['timestamp'].compareTo(b['timestamp']));
      // _activityList = List.from(_activityList)..addAll(doc.data['activities'].values().toList());
    }
    return _activityList.sublist(first, last);
  }
}

final CloudFirestoreService cloudFirestoreService = CloudFirestoreService();
