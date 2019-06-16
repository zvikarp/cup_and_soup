import 'dart:ui' as ui;

import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DialogWidget extends StatelessWidget {
  DialogWidget({
    @required this.child,
    @required this.actionSection,
    @required this.heading,
    this.scrollable = false,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(16.0),
    this.blurColor,
    this.shadowColor,
  });

  final Widget child;
  final Widget heading;
  final Widget actionSection;
  final bool scrollable;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color shadowColor;
  final Color blurColor;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: blurColor ?? themes.load("dialogBlurColor"),
      body: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 6.0,
          sigmaY: 6.0,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              // image: new DecorationImage(
              //   image: new AssetImage("assets/images/dialogBackground.png"),
              //   fit: BoxFit.contain,
              // ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                new BoxShadow(
                  color: shadowColor ?? themes.load("dialogShadowColor"),
                  blurRadius: 20.0,
                )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 42.0, vertical: 80.0),
            child: AspectRatio(
              aspectRatio: 753 / 1183,
              child: Stack(
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/dialogBackground.svg",
                    width: double.infinity,
                    color: themes.load("canvasColor"),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      heading,
                      Expanded(
                        child: scrollable
                            ? SingleChildScrollView(child: child)
                            : Center(child: child),
                      ),
                      actionSection,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
