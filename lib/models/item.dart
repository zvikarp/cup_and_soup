/// Todo object
class Item {
  Item({
    this.barcode,
    this.name,
    this.desc,
    this.image,
    this.price,
    this.tags,
    this.stock,
    this.hechsherim,
  });

  String barcode;
  String name;
  String desc;
  String image;
  double price;
  String tags;
  int stock;
  String hechsherim;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        barcode: json["barcode"],
        name: json["name"],
        desc: json["desc"],
        image: json["image"],
        price: json["price"],
        tags: json["tags"],
        stock: json["stock"],
        hechsherim: json["hechsherim"],
      );

  Map<String, dynamic> toMap() => {
        "barcode": barcode,
        "name": name,
        "desc": desc,
        "image": image,
        "price": price,
        "tags": tags,
        "stock": stock,
        "hechsherim": hechsherim,
      };
}