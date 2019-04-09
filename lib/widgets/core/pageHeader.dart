import 'package:flutter/material.dart';

class PageHeaderWidget extends StatelessWidget {
  PageHeaderWidget({
    Key key,
    @required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
          child: SafeArea(
        child: Container(
          height: 80,
          child: Center(
            child: Text("//$title//", style: TextStyle(
              fontFamily: "BrandFont",
              fontSize: 65,
            ),),
          ),
        ),
      ),
    );
  }
}
