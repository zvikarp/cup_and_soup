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
                  child: item.image != "no image"
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/images/loading.png',
                          image: item.image,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          'assets/images/loading.png',
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
