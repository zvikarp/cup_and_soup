import 'package:flutter/material.dart';

class SnackbarWidget {

  static void show(GlobalKey<ScaffoldState> key, String text) {
    key.currentState.showSnackBar(SnackBar(
      content: Text(text),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //   },
      // ),
    ));
  }
}
