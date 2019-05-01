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

  Widget _badge(String type, String text, context) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(45 / 360),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
        color: type == "sale" ? Theme.of(context).primaryColor : Colors.red,
        child: Text(
          text,
          style: TextStyle(
            color: type == "sale" ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _badgeFinder(context) {
    List tags = item.tags.split(',');
    for (var tag in tags) {
      var t = tag.split(':');
      if (t.length > 1) {
        print(t.first);
        if (t.first == "disc") {
          return _badge("disc", t.last, context);
        } else if (t.first == "sale") {
          return _badge("sale", t.last, context);
        }
      }
    }
    return Container();
  }

  String _hot() {
    List tags = item.tags.split(',');
    if (tags.contains("hot")) {
      return "🔥";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.all(16),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
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
                      _hot() + " ${item.price.toString()} NIS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "PrimaryFont",
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: _badgeFinder(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
