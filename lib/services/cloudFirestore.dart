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
  final _generalRequestsStream = PublishSubject();
  Map<String, dynamic> _userData;
  List<dynamic> _activityList = [];

/* ITEMS >>> */

  Future<List<Item>> getUpdatedItems(DateTime lastUpdatedDateTime, String role) async {
    QuerySnapshot snapshot = await _db.collection('store').where("lastUpdated", isGreaterThan: lastUpdatedDateTime).getDocuments();
    if (snapshot.documents.isNotEmpty)
      return snapshot.documents.map((item) => Item.fromFirestore(item.documentID, item.data)).toList();
    else return [];
  }

/* <<< ITEMS */

  Future<List<String>> getRoles() async {
    if (_userData != null) {
      return _userData['roles'].cast<String>();
    } else {
      await loadUserData();
      if (_userData != null) {
        return _userData['roles'].cast<String>();
      } else
        return null;
    }
  }

  Future<Map<dynamic, dynamic>> getDiscount() async {
    if (_userData != null) {
      return _userData['discount'];
    } else {
      await loadUserData();
      if (_userData != null) {
        return _userData['discount'];
      } else
        return null;
    }
  }

  Future<Map> getUserData() async {
    if (_userData != null) {
      return _userData;
    } else {
      await loadUserData();
      if (_userData != null) {
        return _userData;
      } else
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
      double amount, DateTime dateTime, bool userLimit, int quantity) async {
    String barcode = generateBarcode("M");
    var data = await _db.collection('surpriseBox').document(barcode).get();
    if (data.exists)
      return uploadMoneyBarcode(amount, dateTime, userLimit, quantity);
    else {
      await _db.collection('surpriseBox').document(barcode).setData({
        'type': "money",
        'amount': amount,
        'expiringDate': dateTime,
        'userLimit': userLimit,
        'quantity': quantity,
      });
      return barcode;
    }
  }

  Future<String> uploadDiscountBarcode(double amount, DateTime dateTime,
      int usageLimit, bool userLimit, int quantity) async {
    String barcode = generateBarcode("D");
    var data = await _db.collection('surpriseBox').document(barcode).get();
    if (data.exists)
      return uploadDiscountBarcode(
          amount, dateTime, usageLimit, userLimit, quantity);
    else {
      await _db.collection('surpriseBox').document(barcode).setData({
        'type': "discount",
        'amount': amount,
        'expiringDate': dateTime,
        'usageLimit': usageLimit,
        'userLimit': userLimit,
        'quantity': quantity,
      });
      return barcode;
    }
  }

  Future<String> updateCreditBarcode(double amount, DateTime dateTime) async {
    String barcode = generateBarcode("C");
    var data = await _db.collection('surpriseBox').document(barcode).get();
    if (data.exists)
      return updateCreditBarcode(amount, dateTime);
    else {
      await _db.collection('surpriseBox').document(barcode).setData(
          {'type': "credit", 'amount': amount, 'expiringDate': dateTime});
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
        if (snap.data['client'] == "app") {
          var request = {
            "barcode": snap.data['barcode'],
            "responseCode": snap.data['responseCode'],
          };
          _buyRequestsStream.add(request);
        }
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
        if (snap.data['client'] == "app") {
          var request = {
            "barcode": snap.data['barcode'],
            "responseCode": snap.data['responseCode']
          };
          _generalRequestsStream.add(request);
        }
      }
    });
    _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('credit')
        .snapshots()
        .listen((snap) {
      if (snap.exists) {
        if (snap.data['client'] == "app") {
          var request = {
            "barcode": snap.data['barcode'],
            "responseCode": snap.data['responseCode']
          };
          _generalRequestsStream.add(request);
        }
      }
    });
    _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('discount')
        .snapshots()
        .listen((snap) {
      if (snap.exists) {
        if (snap.data['client'] == "app") {
          var request = {
            "barcode": snap.data['barcode'],
            "responseCode": snap.data['responseCode']
          };
          _generalRequestsStream.add(request);
        }
      }
    });
  }

  Stream subscribeToBuyRequestsStream() {
    return _buyRequestsStream.stream;
  }

  Stream subscribeToGeneralRequestsStream() {
    return _generalRequestsStream.stream;
  }

  void updateStoreStatus(DateTime open, DateTime close) async {
    String uid = await authService.getUid();
    if (uid == null) return;
    Map<String, DateTime> storeData = {
      'openingDate': open,
      'closeingDate': close,
    };
    await _db
        .collection('general')
        .document('updates')
        .updateData({"store": storeData});
  }

  Future<bool> deleteRequest(String barcode) async {
    String type = "";
    if (barcode[0] == "M")
      type = "money";
    else if (barcode[0] == "C")
      type = "credit";
    else if (barcode[0] == "D")
      type = "discount";
    else
      return false;

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
    if (uid == null) return false;
    var data = await _db.collection('users').document(uid).get();
    var userData = {
      "name": data["name"],
      "money": data["money"],
      "allowdCredit": data["allowedCredit"],
      "roles": data["roles"].map((role) => role.toString()).toList(),
      "email": data["email"],
      "discount": data["discount"],
      "disabled": data["disabled"],
    };
    _userData = userData;
    return userData;
  }

  Future loadStoreStatus() async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    var data = await _db.collection('general').document('updates').get();
    var status = {
      "openingDate": data["store"]["openingDate"],
      "closeingDate": data["store"]["closeingDate"],
    };
    return status;
  }

  bool resetUserData() {
    _userData = null;
    return true;
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
      if (oldBarcode != "") {
        await _db.collection('store').document(oldBarcode).delete();
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
      'position': item.position,
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

  Future<bool> sendRequest(String barcode) async {
    String type = "";
    if (barcode[0] == "M")
      type = "money";
    else if (barcode[0] == "D")
      type = "discount";
    else if (barcode[0] == "C")
      type = "credit";
    else
      return false;
    String uid = await authService.getUid();
    if (uid == null) return false;
    var doc = await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document(type)
        .get();
    if (doc.exists) {
      DateTime expiringDate = doc.data['expiringDate'].toDate();
      if (DateTime.now().millisecondsSinceEpoch >
          expiringDate.millisecondsSinceEpoch) {
        await _db
            .collection('users')
            .document(uid)
            .collection('requests')
            .document(type)
            .delete();
      } else {
        return false;
      }
    }
    await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document(type)
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

  Future<bool> deleteBarcode(String barcode) async {
    String uid = await authService.getUid();
    if (uid == null) return false;
    await _db.collection('surpriseBox').document(barcode).delete();
    return true;
  }

  Future<Item> getItem(String barcode) async {
    String uid = await authService.getUid();
    if (uid == null) return null;
    var doc = await _db.collection('store').document(barcode).get();
    if (!doc.exists) return null;
    return Item(
      barcode: barcode,
      name: doc.data['name'],
      desc: doc.data['desc'],
      hechsherim: doc.data['hechsherim'],
      image: doc.data['image'],
      price: doc.data['price'],
      stock: doc.data['stock'],
      tags: doc.data['tags'],
    );
  }

  Future<List<dynamic>> getActivities() async {
    String uid = await authService.getUid();
    _activityList = [];
    await _db
        .collection('users')
        .document(uid)
        .collection('activity')
        .getDocuments()
        .then((snapshot) {
      for (var doc in snapshot.documents) {
        doc.data['activities'].forEach((k, v) {
          Map data = {
            'timestamp': v['timestamp'],
            'desc': v['desc'],
            'money': v['money'],
            'type': v['type'],
          };
          _activityList.add(data);
        });
      }
    });
    _activityList.sort((b, a) => a['timestamp'].compareTo(b['timestamp']));
    return _activityList;
  }

  Future<String> getLastVersion() async {
    String uid = await authService.getUid();
    if (uid == null) return null;
    var doc = await _db.collection('general').document('updates').get();
    return doc.data['appVersion'];
  }
}

final CloudFirestoreService cloudFirestoreService = CloudFirestoreService();
