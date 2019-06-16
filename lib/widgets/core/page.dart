import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PageWidget extends StatefulWidget {
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
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  ScrollController _contentCtr = ScrollController();
  double _yOffset = 0;

  Widget _titleWidget(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _yOffset),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Colors.black,
                height: 60,
                width: double.infinity,
              ),
              Transform.translate(
                offset: Offset(0, -2),
                child: RotatedBox(
                  quarterTurns: 2,
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: AssetImage(
                      "assets/images/navigation.png",
                    ),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment(0, -1),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                child: Text(
                  "- " + widget.title + " -",
                  style: Theme.of(context).textTheme.headline,
                )),
          ),
        ],
      ),
    );
  }

  Widget _headWidget() {
    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(0, -30),
            child: RotatedBox(
              quarterTurns: 2,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: AssetImage(
                  "assets/images/navigation.png",
                ),
                height: 70,
                width: double.infinity,
                alignment: Alignment(0, -1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 20),
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage(
                "assets/images/icon.png",
              ),
              height: 30,
              width: double.infinity,
              alignment: Alignment(0, -1),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentWidget() {
    return NotificationListener<ScrollNotification>(
      onNotification: (info) {
        double editedOffset = (_contentCtr.offset) * 0.4;
        if ((editedOffset < 100) || (_yOffset > -100)) {
          print(editedOffset);
          setState(() {
            _yOffset = 0 - editedOffset;
          });
        }
      },
      child: SingleChildScrollView(
        controller: _contentCtr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.from([Container(height: 130)])
            ..addAll(widget.child == null ? widget.children : [widget.child])
            ..add(Container(height: 80)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _contentWidget(),
        _headWidget(),
        _titleWidget(context),
      ],
    );
  }
}
