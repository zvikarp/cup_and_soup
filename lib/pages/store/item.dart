import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/store/actionSection.dart';
import 'package:cup_and_soup/models/item.dart';

class ItemPage extends StatelessWidget {
  ItemPage({
    @required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 250,
                  child: Hero(
                    tag: item.barcode,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.png',
                      image:
                          'https://www.osem.co.il/tm-content/uploads/2014/12/instant_0016_manaHamaChickenTasteNoodles.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(item.name),
                Text(item.hechsherim),
                Text(item.desc),
                Text(item.tags),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ActionSectionWidget(barcode: item.barcode, price:item.price),
    );
  }
}
