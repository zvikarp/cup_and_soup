import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(45),
      child: FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: AssetImage(
          "assets/images/divider.png",
        ),
        width: 50,
      ),
    );
  }
}
