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

  static void infoBar(BuildContext context, String message) {
    Flushbar f;
    f = Flushbar(
      isDismissible: true,
      mainButton: FlatButton(
        child: Text(
          "Ok",
          style: TextStyle(
              fontFamily: "PrimaryFont", fontSize: 18, color: Colors.blue),
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
        Icons.info,
        size: 28.0,
        color: Colors.blue,
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 6),
    );
    f.show(context);
  }

  static void messsageBar(BuildContext context, String title, String message) {
    Flushbar f;
    f = Flushbar(

      isDismissible: true,
      title: title,
      titleText: Text(
        title,
        style: Theme.of(context).textTheme.body2.merge(TextStyle(color: Colors.white)),
      ),
      message: message,
      messageText: Text(
        message,
        style: Theme.of(context).textTheme.body1.merge(TextStyle(color: Colors.white)),
      ),
      icon: Icon(
        Icons.message,
        size: 28.0,
        color: Colors.green,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.black,
      duration: Duration(days: 30),
    );
    f.show(context);
  }

}
