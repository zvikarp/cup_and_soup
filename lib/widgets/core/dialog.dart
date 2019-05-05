import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  DialogWidget({
    @required this.child,
    @required this.actionSection,
    @required this.heading,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(16.0),
    this.blurColor = const Color(0x10ffffff),
    this.shadowColor = const Color(0xfff9E9E9E),
  });

  final Widget child;
  final Widget heading;
  final Widget actionSection;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color shadowColor;
  final Color blurColor;


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: blurColor,
      body: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 6.0,
          sigmaY: 6.0,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/dialogBackground.png"),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                new BoxShadow(
                  color: shadowColor,
                  blurRadius: 20.0,
                )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 42.0, vertical: 80.0),
            child: AspectRatio(
              aspectRatio: 753 / 1183,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  heading,
                  Expanded(child: SingleChildScrollView(child: child)),
                  actionSection,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
