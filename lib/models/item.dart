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
    this.position,
    this.hechsherim,
  });

  String barcode;
  String name;
  String desc;
  String image;
  double price;
  List<String> tags;
  int stock;
  int position;
  String hechsherim;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        barcode: json["barcode"],
        name: json["name"],
        desc: json["desc"],
        image: json["image"],
        price: json["price"],
        tags: json["tags"],
        stock: json["stock"],
        position: json["position"],
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
        "position": position,
        "hechsherim": hechsherim,
      };
}