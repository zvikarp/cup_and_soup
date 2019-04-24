import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/dialogs/signin.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  _openLogin() {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => SigninDialog(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
   SchedulerBinding.instance.addPostFrameCallback((_) => _openLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(-250, 200),
            child: Transform.rotate(
              angle: -math.pi / 2.0,
              child: Transform.scale(
                scale: 2,
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(1.0, 6.0),
                  blurRadius: 40.0,
                ),
              ],
              ),
              child: ButtonWidget(
                text: "Login",
                onPressed: _openLogin,
                primary: false,
              ),
            ),
          )
        ],
      ),
    );
  }
}
