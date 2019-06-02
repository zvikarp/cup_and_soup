import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(45),
      // child: FadeInImage(
      //   placeholder: MemoryImage(kTransparentImage),
      //   image: AssetImage(
      //     "assets/images/divider.png",
      //   ),
      child: SvgPicture.asset(
        "assets/images/divider.svg",
        width: 50,
        color: Colors.yellow,
      ),
    );
  }
}
