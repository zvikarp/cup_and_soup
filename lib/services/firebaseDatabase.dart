
import 'package:rxdart/subjects.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService {

  FirebaseDatabase _db = FirebaseDatabase.instance;
  Stream<Event> _firebaseItemsStock;

  BehaviorSubject<Map<String,int>> _itemsStock;

  Stream<Map<String,int>> streamItemsStock() {
    if (_firebaseItemsStock == null) {
      _itemsStock = BehaviorSubject();
      _listenToItemStock();
    }
    return _itemsStock.stream;
  }

  void _listenToItemStock() async {
    _firebaseItemsStock = _db.reference().child('store/itemsStock/').onValue;
    _firebaseItemsStock.listen((Event event) {
      Map<String,int> stocks = event.snapshot.value.cast<String,int>();
      print(stocks);
      _itemsStock.add(stocks);
    });
  }

}

final FirebaseDatabaseService firebaseDatabaseService =
    FirebaseDatabaseService();
