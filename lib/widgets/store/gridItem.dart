import 'package:flutter/material.dart';

import 'package:cup_and_soup/models/item.dart';

class GridItemWidget extends StatelessWidget {
  GridItemWidget({
    @required this.item,
    @required this.onTap,
    this.onLongPress,
  });

  final Item item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Hero(
                  tag: item.barcode,
                                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.png',
                    image: 'https://www.osem.co.il/tm-content/uploads/2014/12/instant_0016_manaHamaChickenTasteNoodles.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                "${item.price.toString()} NIS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "PrimaryFont",
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
