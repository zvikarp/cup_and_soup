import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class SnackbarWidget {
  static void errorBar(BuildContext context, String message) {
    Flushbar f;
    f = Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
        child: Text(
          "Ok",
          style: TextStyle(
              fontFamily: "PrimaryFont", fontSize: 18, color: Colors.red),
        ),
        onPressed: () {
          f.dismiss();
        },
      ),
      message: message,
      messageText: Text(
        message,
        style: TextStyle(
            fontFamily: "PrimaryFont", fontSize: 18, color: Colors.white),
      ),
      icon: Icon(
        Icons.error_outline,
        size: 28.0,
        color: Colors.red,
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 6),
    );
    f.show(context);
  }
  static void successBar(BuildContext context, String message) {
    Flushbar f;
    f = Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
        child: Text(
          "Ok",
          style: TextStyle(
              fontFamily: "PrimaryFont", fontSize: 18, color: Color(0xffd8d738)),
        ),
        onPressed: () {
          f.dismiss();
        },
      ),
      message: message,
      messageText: Text(
        message,
        style: TextStyle(
            fontFamily: "PrimaryFont", fontSize: 18, color: Colors.white),
      ),
      icon: Icon(
        Icons.check,
        size: 28.0,
        color: Color(0xffd8d738),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 6),
    );
    f.show(context);
  }

  static void show(
      BuildContext context, String title, String message, String type) {
    Flushbar(
      title: "Hey Ninja",
      message: message,
      duration: Duration(seconds: 5),
    )..show(context);
    // key.currentState.showSnackBar(SnackBar(
    //   // content: Text(text),
    //   content: Image.asset(
    //       "assets/images/navBar.png",
    //       height: 70,
    //       width: double.infinity,
    //       fit: BoxFit.cover,
    //     ),

    //   backgroundColor: Colors.transparent,
    //   action: SnackBarAction(
    //     label: 'Ok',
    //     textColor: Color(0xffd8d738),
    //     onPressed: () {
    //       key.currentState.hideCurrentSnackBar();
    //     },
    //   ),
    // ));
  }
}
