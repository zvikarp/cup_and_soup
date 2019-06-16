import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CenterWidget extends StatelessWidget {
  CenterWidget({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          // FadeInImage(
          //   placeholder: MemoryImage(kTransparentImage),
          //   image: AssetImage("assets/images/center.png"),
          // ),
          SvgPicture.asset(
          "assets/images/center.svg",
          fit: BoxFit.contain,
          height: 110,
          color: themes.load("centerColor"),
        ),
          Container(
            height: 110,
            child: child,
          ),
        ],
      ),
    );
  }
}
