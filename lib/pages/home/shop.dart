import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/pages/item.dart';
import 'package:cup_and_soup/widgets/shop/gridItem.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key key}) : super(key: key);

  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Map<String, Widget> _gridListItems = {
    "Item 1": ItemPage(name: "item 1",),
    "Item 2": ItemPage(name: "item 1",),
    "Item 3": ItemPage(name: "item 1",),
    "Item 4": ItemPage(name: "item 1",),
    "Item 5": ItemPage(name: "item 1",),
    "Item 6": ItemPage(name: "item 1",),
    "Item 7": ItemPage(name: "item 1",),
  };

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "shop",
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _gridListItems.length,
        itemBuilder: (context, index) {
          return GridItemWidget(
            text: _gridListItems.keys.toList()[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        _gridListItems.values.toList()[index]),
              );
            },
          );
        },
      ),
    );
  }
}
