
import 'package:rxdart/subjects.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService {

  FirebaseDatabase _db = FirebaseDatabase.instance;
  Stream<Event> _firebaseItemsStock;

  BehaviorSubject _itemsStock = BehaviorSubject();

  Stream streamItemsStock() {
    if (_firebaseItemsStock == null) _listenToItemStock();
    return _itemsStock.stream;
  }

  void _listenToItemStock() async {
    DataSnapshot _stockSnapshot = await _db.reference().child('store/itemsStock').once();
    _firebaseItemsStock = _db.reference().child('store/itemsStock/').onChildChanged;
    _firebaseItemsStock.listen((Event snapshot) {
      print(snapshot.snapshot.key);
      print(snapshot.snapshot.value);
      print(snapshot.previousSiblingKey);
      print(snapshot.runtimeType);
    });
  }

}

final FirebaseDatabaseService firebaseDatabaseService =
    FirebaseDatabaseService();
