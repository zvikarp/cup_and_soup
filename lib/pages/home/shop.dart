import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/pages/shop/item.dart';
import 'package:cup_and_soup/pages/shop/editItem.dart';
import 'package:cup_and_soup/widgets/shop/gridItem.dart';
import 'package:cup_and_soup/models/item.dart';

class ShopPage extends StatefulWidget {
  ShopPage({
    Key key,
    this.isAdmin = false,
  }) : super(key: key);

  bool isAdmin;

  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Widget _addItemButton() {
    return GridTile(
      child: Container(
        margin: EdgeInsets.all(16),
        child: Center(
          child: ButtonWidget(
            text: "Add Item",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditItemPage(newItem: true),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "shop",
      child: StreamBuilder(
          stream: Firestore.instance.collection('store').snapshots(),
          builder: (context, snapshot) {
            int length = 0;
            if (snapshot.hasData && snapshot.data.documents != null)
              length += (snapshot.data.documents.length ?? 0);
            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: widget.isAdmin ? length + 1 : length,
              itemBuilder: (context, index) {
                if (index == length) {
                  return _addItemButton();
                }
                var doc = snapshot.data.documents[index];
                Item item = Item(
                  barcode: doc.documentID,
                  name: doc['name'],
                  desc: doc['desc'],
                  image: doc['image'],
                  price: doc['price'],
                  stock: doc['stock'],
                  tags: doc['tags'],
                  hechsherim: doc['hechsherim'],
                );

                return GridItemWidget(
                  price: doc['price'],
                  image: doc['image'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemPage(
                              item: item,
                            ),
                      ),
                    );
                  },
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemPage(
                              item: item,
                            ),
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
