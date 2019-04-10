import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/pageHeader.dart';

class PageWidget extends StatelessWidget {
  PageWidget({
    @required this.title,
    this.child,
    this.children,
  })  : assert((child != null) || (children != null)),
        assert((child == null) || (children == null));

  final String title;
  final Widget child;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          PageHeaderWidget(
            title: title,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                              child: child != null
                    ? child
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
