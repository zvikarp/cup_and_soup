import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CenterWidget extends StatelessWidget {
  CenterWidget({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage("assets/images/center.png"),
        ),
        Container(
          height: 110,
          child: child,
        ),
      ],
    );
  }
}
