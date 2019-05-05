import 'package:flutter/material.dart';

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

  Widget _titleWidget(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 40),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.from([_titleWidget(context)])
              ..addAll(child == null ? children : [child]),
          ),
        ),
        IgnorePointer(
          child: Image.asset("assets/images/header.png"),
        ),
      ],
    );
  }
}
