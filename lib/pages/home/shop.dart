import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
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
  List<Map<String, dynamic>> _gridListItems = [
    {
      'name': 'item 1',
      'desc': 'desc 1',
      'price': 25.1,
      'tags': 'tag a, tag b',
      'stock': 5
    },
    {
      'name': 'item 2',
      'desc': 'desc 2',
      'price': 25.1,
      'tags': 'tag a, tag b',
      'stock': 5
    },
    {
      'name': 'item 3',
      'desc': 'desc 3',
      'price': 25.1,
      'tags': 'tag a, tag b',
      'stock': 5
    },
    {
      'name': 'item 4',
      'desc': 'desc 4',
      'price': 25.1,
      'tags': 'tag a, tag b',
      'stock': 5
    },
    {
      'name': 'item 5',
      'desc': 'desc 5',
      'price': 25.1,
      'tags': 'tag a, tag b',
      'stock': 5
    },
    {
      'name': 'item 6',
      'desc': 'desc 6',
      'price': 25.1,
      'tags': 'tag a, tag b',
      'stock': 5
    },
    {
      'name': 'item 7',
      'desc': 'desc 7',
      'price': 25.1,
      'tags': 'tag a, tag b',
      'stock': 5
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "shop",
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: widget.isAdmin ? _gridListItems.length + 1 : _gridListItems.length,
        itemBuilder: (context, index) {
          if (index == _gridListItems.length) {
            return GridItemWidget(
              text: "Add Item",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemPage(
                          item: _gridListItems[0],
                        ),
                  ),
                );
              },
              onLongPress: widget.isAdmin ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemPage(
                          item: _gridListItems[0],
                        ),
                  ),
                );
              } : () {},
            );
          }
          return GridItemWidget(
            text: _gridListItems[index]["name"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemPage(
                        item: _gridListItems[index],
                      ),
                ),
              );
            },
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditItemPage(
                        item: _gridListItems[index],
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
