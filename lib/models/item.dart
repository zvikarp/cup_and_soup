/// Todo object
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
  String name;
  String desc;
  String remoteImage;
  String localImage;
  double price;
  List<String> tags;
  int stock;
  int position;
  String hechsherim;
  DateTime lastUpdated;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        barcode: json["barcode"],
        name: json["name"],
        desc: json["desc"],
        remoteImage: json["remoteImage"],
        localImage: json["localImage"],
        price: json["price"],
        tags: json["tags"].cast<String>(),
        stock: json["stock"],
        position: json["position"],
        hechsherim: json["hechsherim"],
        lastUpdated: json["lastUpdated"],
      );

  factory Item.fromFirestore(String barcode, Map<String, dynamic> json) => Item(
        barcode: barcode,
        name: json["name"],
        desc: json["desc"],
        remoteImage: json["image"],
        localImage: "",
        price: json["price"].toDouble(),
        tags: json["tags"].cast<String>(),
        stock: json["stock"],
        position: json["position"],
        hechsherim: json["hechsherim"],
        lastUpdated: json["lastUpdated"].toDate(),
      );

  factory Item.fromSqflite(Map<String, dynamic> json) => Item(
        barcode: json["barcode"],
        name: json["name"],
        desc: json["desc"],
        remoteImage: json["remoteImage"],
        localImage: json["localImage"],
        price: json["price"],
        tags: json["tags"].split(","),
        stock: json["stock"],
        position: json["position"],
        hechsherim: json["hechsherim"],
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
        "name": name,
        "desc": desc,
        "remoteImage": remoteImage,
        "localImage": localImage,
        "price": price,
        "tags": tags.join(","),
        "stock": stock,
        "position": position ?? 0,
        "hechsherim": hechsherim,
      };
}