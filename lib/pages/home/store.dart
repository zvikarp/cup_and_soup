import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/pages/store/item.dart';
import 'package:cup_and_soup/pages/store/editItem.dart';
import 'package:cup_and_soup/widgets/store/gridItem.dart';
import 'package:cup_and_soup/models/item.dart';

class StorePage extends StatefulWidget {
  StorePage({
    Key key,
    this.isAdmin = false,
  }) : super(key: key);

  final bool isAdmin;

  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
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
                  item: item,
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
