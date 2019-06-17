import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:rxdart/subjects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/services/cloudFunctions.dart';
import 'package:cup_and_soup/services/firebaseStorage.dart';
import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/services/sharedPreferences.dart';
import 'package:cup_and_soup/models/user.dart';
import 'package:cup_and_soup/models/item.dart';

class CloudFirestoreService {
  final Firestore _db = Firestore.instance;
  final _buyRequestsStream = PublishSubject();
  final _generalRequestsStream = PublishSubject();
  List<dynamic> _activityList = [];

/* ITEMS >-> */

  Future<Map<String, Item>> getUpdatedItems(
      DateTime lastUpdatedDateTime, String role) async {
    QuerySnapshot snapshot = await _db
        .collection('store')
        .where("lastUpdated", isGreaterThan: lastUpdatedDateTime)
        .getDocuments();
    Map<String, Item> itemsMap = {};
    snapshot.documents.forEach((i) {
      itemsMap.putIfAbsent(
          i.documentID, () => Item.fromFirestore(i.documentID, i.data));
    });
    return itemsMap;
  }

/* <-< ITEMS */

/* USER >-> */

  BehaviorSubject<User> _userDataStream;
  User _user;

  Stream<User> streamUserData() {
    if (_userDataStream == null) {
      _userDataStream = BehaviorSubject();
      listenToUserData();
    }
    return _userDataStream.stream;
  }

  void listenToUserData() async {
    _user = await sharedPreferencesService.getUserDetailes();
    _userDataStream.add(_user);
    String uid = await authService.getUid();
    _db
        .collection('users')
        .document(uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      Map<String, dynamic> userAsMap = snapshot.data;
      userAsMap.putIfAbsent("uid", () => uid);
      _user = User.fromMap(userAsMap);
      _userDataStream.add(_user);
      sharedPreferencesService.updatedUserDetailes(_user);
    });
  }

  Future<bool> resetUserData() async {
    _user = User.defaultUser();
    await _userDataStream.drain();
    await _userDataStream.close();
    await sharedPreferencesService.updatedUserDetailes(_user);
    return true;
  }

/* <-< USER */

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

  Future<String> uploadNoteBarcode(String note, DateTime dateTime,
      int usageLimit, bool userLimit, int quantity) async {
    String barcode = generateBarcode("N");
    var data = await _db.collection('surpriseBox').document(barcode).get();
    if (data.exists)
      return uploadNoteBarcode(
          note, dateTime, usageLimit, userLimit, quantity);
    else {
      await _db.collection('surpriseBox').document(barcode).setData({
        'type': "note",
        'note': note,
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
        .document('note')
        .snapshots()
        .listen((snap) {
      if (snap.exists) {
        if (snap.data['client'] == "app") {
          var request = {
            "barcode": snap.data['barcode'],
            "responseCode": snap.data['responseCode'],
            "note": snap.data['note'],
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

  Future<String> updateItem(Item item,
      [File image, String imageState, String oldBarcode = ""]) async {
    String uid = await authService.getUid();
    if (uid == null)
      return "Can't connect to your account, try restarting the app.";
    String imageUrl = item.remoteImage;
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
    await cloudFunctionsService.updateItemStock(item.barcode, item.stock);
    await _db.collection('store').document(item.barcode.toString()).updateData({
      'name': item.name,
      'desc': item.desc,
      'price': item.price,
      'image': imageUrl,
      'tags': item.tags,
      'stock': item.stock,
      'position': item.position,
      'hechsherim': item.hechsherim,
      'lastUpdated': item.lastUpdated
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

  Future<bool> requestRefund(String aid) async {
    String uid = await authService.getUid();
    var doc = await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('refund')
        .get();
    if (doc.exists) {
      DateTime expiringDate = doc.data['expiringDate'].toDate();
      if (DateTime.now().millisecondsSinceEpoch >
          expiringDate.millisecondsSinceEpoch) {
        await _db
            .collection('users')
            .document(uid)
            .collection('requests')
            .document('refund')
            .delete();
      } else {
        return false;
      }
    }
    await _db
        .collection('users')
        .document(uid)
        .collection('requests')
        .document('refund')
        .setData({
      'aid': aid,
      'client': 'server',
      'expiringDate': DateTime.now().add(Duration(minutes: 60)),
    });
    // SnackbarWidget.infoBar(context,
    //     "Your request has been sent, we well notify you in under 1 hour if your request has been exepted.");
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
    else if (barcode[0] == "N")
      type = "note";
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
      remoteImage: doc.data['image'],
      localImage: "",
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
            'aid': v['aid'] ?? "not provided",
            'status': v['status'] ?? "success",
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

  void updateAdminFcmToken(String fcmToken) async {
    String uid = await authService.getUid();
    if (uid == null) return;
    await _db.collection('admin').document('adminFcmTokens').updateData({
      uid: fcmToken,
    });
    return;
  }
}

final CloudFirestoreService cloudFirestoreService = CloudFirestoreService();
