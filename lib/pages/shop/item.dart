import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/shop/actionSection.dart';
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
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    height: 200,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/room10.png',
                      image: item.image,
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
      bottomNavigationBar: ActionSectionWidget(),
    );
  }
}
