import 'dart:io';

import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/services/firebaseDatabase.dart';
import 'package:rxdart/subjects.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' show get;

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
        "remoteImage TEXT,"
        "localImage TEXT,"
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

  Map<String, BehaviorSubject<String>> _settingsStreamMap = {};

  Stream streamSetting(String setting) {
    if (!_settingsStreamMap.containsKey(setting)) {
      _settingsStreamMap.putIfAbsent(setting, () => BehaviorSubject());
      getSetting(setting).then((value) {
        _settingsStreamMap[setting].add(value);
      });
    }
    return _settingsStreamMap[setting].stream;
  }

  void updateStreamSetting(String key, String value) {
    if (_settingsStreamMap.containsKey(key)) _settingsStreamMap[key].add(value);
  }

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
  Map<String,Item> _items = {};

  Stream streamItems() => _itemsStream.stream;

  void updateItems(Map<String,Item> items) {
    _items = items;
    _itemsStream.add(items.values.toList());
  }

  void loadItems(String role) async {
    Map<String,Item> localItems = await getLocalItems(role);
    updateItems(localItems);
    String lastUpdatedAsString =
        await getSetting("lastUpdatedStore", DateTime(1970).toString());
    DateTime lastUpdated = dateTimeUtil.dateStringToDate(lastUpdatedAsString);
    Map<String,Item> newItems =
        await cloudFirestoreService.getUpdatedItems(lastUpdated, role);
    Map<String,Item> updatedItems = mergeUpdatedItems(_items, newItems);
    updateItems(updatedItems);
    newItems.forEach((k,v) => print(k)); 
    updateLocaleItems(localItems, newItems);
    DateTime lastItemUpdated = getLastItemUpdated(newItems);
    if (lastItemUpdated != null)
      await updateSetting("lastUpdatedStore", lastItemUpdated.toString());
    _listenToStockChanges();
  }

  void _listenToStockChanges() {
    firebaseDatabaseService.streamItemsStock().listen((Map<String,int> snapshot) {
      List<String> currentItemsBarcodes = _items.keys.toList();
      Map<String,Item> itemsMap = Map.from(_items);
      for (String barcode in snapshot.keys) {
        if (itemsMap.containsKey(barcode)) {
          itemsMap[barcode].stock = snapshot[barcode];
          updateLocaleItem(itemsMap[barcode]);
          currentItemsBarcodes.remove(barcode);
        }
      }
      updateItems(itemsMap);
      if (currentItemsBarcodes.length > 0) _deleteOldItems(currentItemsBarcodes);
    });
  }

  void _deleteOldItems(List<String> currentItemsBarcodes) {
    Map<String,Item> items = Map.from(_items);
    currentItemsBarcodes.forEach((barcode) {
      items.remove(barcode);
      removeLocaleItem(_items[barcode]);
      deleteLocaleImage(_items[barcode]);
    });
    updateItems(items);
  }

  DateTime getLastItemUpdated(Map<String,Item> items) {
    if (items.length < 1)
      return null;
    else
      return items.values
          .reduce((a, b) => a.lastUpdated.isAfter(b.lastUpdated) ? a : b)
          .lastUpdated;
  }

  Map<String,Item> mergeUpdatedItems(Map<String,Item> initalItems, Map<String,Item> newItems) {
    for (Item item in newItems.values) {
      String barcode = item.barcode;
      if (!newItems.containsKey(barcode))
        initalItems.putIfAbsent(barcode, () => item);
    }
    return initalItems;
  }

  void updateLocaleItems(Map<String,Item> initalItems, Map<String,Item> newItems) {
    for (Item item in newItems.values) {
      String barcode = item.barcode;
      if (initalItems.containsKey(barcode))
        updateLocaleItem(item);
      else
        setLocaleItem(item);
      updateImage(item);
    }
  }

  void updateLocaleItem(Item item) async {
    final db = await database;
    await db.update("Items", item.toSqlMap(),
        where: "barcode = ?", whereArgs: [item.barcode]);
  }

  void setLocaleItem(Item item) async {
    final db = await database;
    await db.insert("Items", item.toSqlMap());
  }

  void removeLocaleItem(Item item) async {
    final db = await database;
    await db.delete("Items", where: "barcode = ?", whereArgs: [item.barcode]);
  }

  void updateImage(Item item) async {
    if ((item.remoteImage == "no image") || (item.remoteImage == "")) return;
    var image = await get(item.remoteImage);
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, item.barcode + '.png');
    File file = File(path);
    file.writeAsBytesSync(image.bodyBytes);
    item.localImage = path;
    updateLocaleItem(item);
  }

  void deleteLocaleImage(Item item) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, item.barcode + '.png');
    Directory imageDir = Directory(path);
    imageDir.delete();
  }

  Future<Map<String,Item>> getLocalItems(String role) async {
    final db = await database;
    var itemsList = await db.query("Items", orderBy: "position");
    Map<String,Item> itemsMap = {};
    itemsList.forEach((i) => itemsMap.putIfAbsent(i['barcode'], () => Item.fromSqflite(i)));
    return itemsMap;
  }

  Future<Item> getLocalItem(String barcode) async {
    final db = await database;
    var res =
        await db.query("Items", where: "barcode = ?", whereArgs: [barcode]);
    if (res.isNotEmpty) {
      return Item.fromSqflite(res.first);
    } else {
      return null;
    }
  }

  /* <<< ITEMS */

}

final SqfliteService sqfliteService = SqfliteService();
