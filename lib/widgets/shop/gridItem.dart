import 'package:flutter/material.dart';

class GridItemWidget extends StatelessWidget {
  GridItemWidget({
    @required this.price,
    @required this.image,
    @required this.onTap,
    this.onLongPress,
  });

  final double price;
  final String image;
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
              Opacity(
                opacity: 0.2,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/room10.png',
                    image: 'https://www.osem.co.il/tm-content/uploads/2014/12/instant_0016_manaHamaChickenTasteNoodles.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                "${price.toString()} NIS",
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
