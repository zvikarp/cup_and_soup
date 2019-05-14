import 'dart:io';

import 'package:cup_and_soup/models/item.dart';
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
    String lastUpdatedAsString =
        await getSetting("lastUpdatedStore", DateTime(1970).toString());
    DateTime lastUpdated = dateTimeUtil.dateStringToDate(lastUpdatedAsString);
    List<Item> newItems =
        await cloudFirestoreService.getUpdatedItems(lastUpdated, role);
    List<Item> updatedItems = mergeUpdatedItems(_items, newItems);
    updateItems(updatedItems);
    updateLocalItems(localItems, newItems);
    DateTime lastItemUpdated = getLastItemUpdated(newItems);
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
      int index =
          initalItems.indexWhere((Item item) => item.barcode == barcode);
      if (index < 0)
        initalItems.add(item);
      else
        initalItems[index] = item;
    }
    return initalItems;
  }

  void updateLocalItems(List<Item> initalItems, List<Item> newItems) {
    for (Item item in newItems) {
      String barcode = item.barcode;
      int index =
          initalItems.indexWhere((Item item) => item.barcode == barcode);
      if (index >= 0)
        updateLocalItem(item);
      else
        setLocalItem(item);
      updateImage(item);
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

  void updateImage(Item item) async {
    if ((item.remoteImage == "no image") || (item.remoteImage == "")) return;
    var image = await get(item.remoteImage);
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, item.barcode + '.png');
    File file = File(path);
    file.writeAsBytesSync(image.bodyBytes);
    item.localImage = path;
    updateLocalItem(item);
  }

  Future<List<Item>> getLocalItems(String role) async {
    final db = await database;
    var itemsList = await db.query("Items", orderBy: "position");
    List<Item> list = itemsList.isNotEmpty
        ? itemsList.map((i) => Item.fromSqflite(i)).toList()
        : [];
    return list;
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
