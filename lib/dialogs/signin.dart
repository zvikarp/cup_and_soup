import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/pages/home.dart';

class SigninDialog extends StatefulWidget {
  @override
  _SigninDialogState createState() => _SigninDialogState();
}

class _SigninDialogState extends State<SigninDialog> {
  void _signInUser() async {
    String uid = await authService.getUid();
    if ((uid == null) || (uid == ""))
      _signInUser();
    else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void initState() {
    super.initState();
    _signInUser();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      heading: Container(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 70, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "logging in with Google...",
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      ),
      actionSection: Container(),
    );
  }
}
