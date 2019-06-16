import 'package:cup_and_soup/utils/localizations.dart';
import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/widgets/store/displayImage.dart';

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
    List tags = item.tags;
    for (var tag in tags) {
      var t = tag.split(':');
      if (t.length > 1) {
        if (t.first == "disc") {
          return _badge("disc", t.last, context);
        } else if (t.first == "sale") {
          return _badge("sale", t.last, context);
        }
      }
    }
    return Container();
  }

  String _visible() {
    List tags = item.tags;
    if (tags.contains("setting:visible")) {
      return "";
    }
    return "🙈";
  }

  String _hot() {
    List tags = item.tags;
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
          // foregroundDecoration: item.stock < 1
          //     ? BoxDecoration(
          //         color: Colors.grey,
          //         backgroundBlendMode: BlendMode.saturation,
          //       )
          //     : BoxDecoration(),
          margin: EdgeInsets.all(16),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Hero(
                          tag: item.barcode,
                          child: DisplayImageWidget(
                            localImage: item.localImage,
                            remoteImage: item.remoteImage,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _visible() + _hot() + " " + item.price.toString() + " " + translate.text("store:p-itemPrice"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title.merge(TextStyle(
                          color: item.stock < 1
                              ? themes.load("disabled")
                              : themes.load("title"))),
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
