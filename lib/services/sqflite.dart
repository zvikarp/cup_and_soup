import 'dart:io';

import 'package:cup_and_soup/models/item.dart';
import 'package:rxdart/subjects.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/utils/dateTime.dart';

class SqfliteService {
  /* SETUP >>> */

  static final SqfliteService db = SqfliteService();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: _createTables,
    );
  }

  Future _createTables(Database db, int version) async {
    await db.execute("CREATE TABLE Items ("
        "barcode TEXT PRIMARY KEY,"
        "name TEXT,"
        "price REAL,"
        "image TEXT,"
        "desc TEXT,"
        "tags TEXT,"
        "hechsherim TEXT,"
        "stock INTEGER,"
        "position INTEGER"
        ")");
    await db.execute("CREATE TABLE Settings ("
        "Key TEXT PRIMARY KEY,"
        "value TEXT"
        ")");
  }

  /* <<< SETUP */

  /* SETTINGS >>> */

  Future<String> getSetting(String key, [String initValue]) async {
    final db = await database;
    var res = await db.query("Settings", where: "key = ?", whereArgs: [key]);
    if (res.isNotEmpty) {
      return res.first['value'];
    } else if (initValue != null) {
      setSetting(key, initValue);
      return initValue;
    } else {
      return null;
    }
  }

  Future setSetting(String key, String value) async {
    final db = await database;
    await db.rawInsert(
        "INSERT Into Settings (key, value)"
        " VALUES (?,?)",
        [key, value]);
  }

  Future updateSetting(String key, String value) async {
    final db = await database;
    await db.update("Settings", {'key': key, 'value': value},
        where: "key = ?", whereArgs: [key]);
  }

  /* <<< SETTINGS */

  /* ITEMS >>> */

  BehaviorSubject<List<Item>> _itemsStream = BehaviorSubject();
  List<Item> _items = [];

  Stream streamItems() => _itemsStream.stream;
  void updateItems(List<Item> items) {
    print(items);
    _items = items;
    _itemsStream.add(items);
  }

  void loadItems(String role) async {
    List<Item> localItems = await getLocalItems(role);
    updateItems(localItems.toList());
    print("1 > " + localItems.toString());
    String lastUpdatedAsString =
        await getSetting("lastUpdatedStore", DateTime(1970).toString());
        print("l1" + localItems.toString());
    DateTime lastUpdated = dateTimeUtil.dateStringToDate(lastUpdatedAsString);
    print("2 > " + lastUpdated.toString());
    print("l2" + localItems.toString());
    List<Item> newItems =
        await cloudFirestoreService.getUpdatedItems(lastUpdated, role);
        print("3 > " + newItems.toString());
        print("l3" + localItems.toString());
    List<Item> updatedItems = mergeUpdatedItems(_items, newItems);
    print("4 > " + updatedItems.toString());
    print("l4" + localItems.toString());
    updateItems(updatedItems);
    print("l5" + localItems.toString());
    updateLocalItems(localItems, newItems);
    DateTime lastItemUpdated = getLastItemUpdated(newItems);
    print("5 > " + lastItemUpdated.toString());
    if (lastItemUpdated != null)
      await updateSetting("lastUpdatedStore", lastItemUpdated.toString());
  }

  DateTime getLastItemUpdated(List<Item> items) {
    if (items.length < 1)
      return null;
    else
      return items
          .reduce((a, b) => a.lastUpdated.isAfter(b.lastUpdated) ? a : b)
          .lastUpdated;
  }

  List<Item> mergeUpdatedItems(List<Item> initalItems, List<Item> newItems) {
    for (Item item in newItems) {
      String barcode = item.barcode;
      print("6.5 > " + barcode);
      int index =
          initalItems.indexWhere((Item item) => item.barcode == barcode);
      if (index < 0) {
      print("6 > " + item.toString());
        initalItems.add(item);
       } else{
        initalItems[index] = item;
        print("7 > " + item.toString());}
    }
    return initalItems;
  }

  void updateLocalItems(List<Item> initalItems, List<Item> newItems) {
    for (Item item in newItems) {
      String barcode = item.barcode;
      print("10 > " + barcode);
      int index =
          initalItems.indexWhere((Item item) => item.barcode == barcode);
      print("7.4 > " + initalItems.toString());
      if (index > 0) {
        print("7.5 > " + index.toString());
        print("8 > " + item.toString());
        updateLocalItem(item);}
      else {
        setLocalItem(item);
        print("9 > " + item.toString());}
    }
  }

  void updateLocalItem(Item item) async {
    final db = await database;
    await db.update("Items", item.toSqlMap(),
        where: "barcode = ?", whereArgs: [item.barcode]);
  }

  void setLocalItem(Item item) async {
    final db = await database;
    await db.insert("Items", item.toSqlMap());
  }

  Future<List<Item>> getLocalItems(String role) async {
    final db = await database;
    var itemsList = await db.query("Items", orderBy: "position");
    List<Item> list = itemsList.isNotEmpty
        ? itemsList.map((i) => Item.fromSqflite(i)).toList()
        : [];
    return list;
  }

  /* <<< ITEMS */

}

final SqfliteService sqfliteService = SqfliteService();
