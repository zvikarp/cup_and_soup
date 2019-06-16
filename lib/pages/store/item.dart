import 'package:cup_and_soup/utils/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/selectable_tags.dart';

import 'package:cup_and_soup/widgets/store/actionSection.dart';
import 'package:cup_and_soup/widgets/store/displayImage.dart';
import 'package:cup_and_soup/models/item.dart';

class ItemPage extends StatelessWidget {
  ItemPage({
    @required this.item,
  });

  final Item item;

  List<Tag> _getTags() {
    List<String> tags = [];
    for (String t in item.tags) {
      if (t.split(':').first != "setting") tags.add(t);
    }
    return (tags).map((tag) {
      return Tag(
        title: tag.split(':').last,
        active: false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: translate.rtl() ? Alignment.topRight : Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.navigate_before,
                          size: 42,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.all(36),
                        height: 230,
                        child: Hero(
                            tag: item.barcode,
                            child: DisplayImageWidget(
                              localImage: item.localImage,
                              remoteImage: item.remoteImage,
                            )),
                      ),
                    ),
                    Positioned(
                      right: translate.rtl() ? null : 60,
                      left: translate.rtl() ? 60 : null,
                      top: 40.0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: item.stock > 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        child: Text(
                          item.stock > 0 ? translate.text("item:p-inStock") : translate.text("item:p-outOfStock"),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  item.getName(translate.currentLanguage),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "PrimaryFont", fontSize: 42),
                ),
                Text(
                  translate.text("item:p-hechesher") +
                      ": " +
                      (item.getHechsherim(translate.currentLanguage).toString() ??
                          translate.text("item:p-notKosher")),
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Container(
                  alignment: Alignment(-1, 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 43),
                  child: Text(item.getDesc(translate.currentLanguage),),
                ),
                SelectableTags(
                  backgroundContainer: Theme.of(context).canvasColor,
                  activeColor: Colors.black,
                  color: Colors.black,
                  textActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                  textStyle: Theme.of(context).textTheme.body1,
                  tags: _getTags(),
                  columns: 3,
                  onPressed: (tag) => print(tag),
                ),
                SizedBox(height: 42),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          ActionSectionWidget(barcode: item.barcode, price: item.price),
    );
  }
}
