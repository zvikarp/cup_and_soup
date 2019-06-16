import 'dart:convert';

class Item {
  Item({
    this.barcode,
    this.name,
    this.desc,
    this.remoteImage,
    this.localImage,
    this.price,
    this.tags,
    this.stock,
    this.position,
    this.hechsherim,
    this.lastUpdated,
  });

  String barcode;
  Map<String, String> name;
  Map<String, String> desc;
  String remoteImage;
  String localImage;
  double price;
  List<String> tags;
  int stock;
  int position;
  Map<String, String> hechsherim;
  DateTime lastUpdated;

  String getName(String lang) {
    if (name[lang] != null) return name[lang];
    return "---";
  }

  String getDesc(String lang) {
    if (desc[lang] != null) return desc[lang];
    return "---";
  }

  String getHechsherim(String lang) {
    if (hechsherim[lang] != null) return hechsherim[lang];
    return "---";
  }

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        barcode: json["barcode"],
        name: json["name"].cast<String, String>(),
        desc: json["desc"].cast<String, String>(),
        remoteImage: json["remoteImage"],
        localImage: json["localImage"],
        price: json["price"],
        tags: json["tags"].cast<String>(),
        stock: json["stock"],
        position: json["position"],
        hechsherim: json["hechsherim"].cast<String, String>(),
        lastUpdated: json["lastUpdated"],
      );

  factory Item.fromFirestore(String barcode, Map<String, dynamic> json) => Item(
        barcode: barcode,
        name: json["name"].cast<String, String>(),
        desc: json["desc"].cast<String, String>(),
        remoteImage: json["image"],
        localImage: "",
        price: json["price"].toDouble(),
        tags: json["tags"].cast<String>(),
        stock: json["stock"],
        position: json["position"],
        hechsherim: json["hechsherim"].cast<String, String>(),
        lastUpdated: json["lastUpdated"].toDate(),
      );

  factory Item.fromSqflite(Map<String, dynamic> json) => Item(
        barcode: json["barcode"],
        name: jsonDecode(json["name"]).cast<String, String>(),
        desc: jsonDecode(json["desc"]).cast<String, String>(),
        remoteImage: json["remoteImage"],
        localImage: json["localImage"],
        price: json["price"],
        tags: json["tags"].split(","),
        stock: json["stock"],
        position: json["position"],
        hechsherim: jsonDecode(json["hechsherim"]).cast<String, String>(),
        lastUpdated: json["lastUpdated"] ?? null,
      );

  Map<String, dynamic> toMap() => {
        "barcode": barcode,
        "name": name,
        "desc": desc,
        "remoteImage": remoteImage,
        "localImage": localImage,
        "price": price,
        "tags": tags,
        "stock": stock,
        "position": position ?? 0,
        "hechsherim": hechsherim,
        "lastUpdated": lastUpdated,
      };

  Map<String, dynamic> toSqlMap() => {
        "barcode": barcode,
        "name": json.encode(name),
        "desc": json.encode(desc),
        "remoteImage": remoteImage,
        "localImage": localImage,
        "price": price,
        "tags": tags.join(","),
        "stock": stock,
        "position": position ?? 0,
        "hechsherim": json.encode(hechsherim),
      };
}
