import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/widgets/core/pageHeader.dart';
import 'package:cup_and_soup/widgets/core/center.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';

class SigninPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _phoneNumber = "";
  String _uid = "";
  int step = 1;

  String validatePhoneNumber() {
    String input = _phoneNumberController.text.toString();
    if ((input == "") || (input == null)) {
      SnackbarWidget.show(_scaffoldKey, "Please enter your phone number.");
      print("sfsdf");
      return null;
    } else if (input.length != 9) {
      SnackbarWidget.show(_scaffoldKey, "The entered number doesn't exist.");
      return null;
    }
    setState(() {
     _phoneNumber = "+972" + input; 
    });
    return _phoneNumber;
  }

  Widget step1() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign in to your Cup&Soup account:',
            style: TextStyle(
              fontFamily: "PrimaryFont",
              fontSize: 22,
            ),
          ),
          CenterWidget(
            child: Center(
              child: Container(
                width: 180,
                child: TextFormField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: _phoneNumberController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "5X-XXX-XXXX",
                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: 24,
                    ),
                    prefixText: "+927 ",
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Phone number (+x xxx-xxx-xxxx)';
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: ButtonWidget(
              onPressed: () {
                String phoneNumber = validatePhoneNumber();
                if (phoneNumber == null) return;
                authService.verifyPhoneNumber(phoneNumber, context);
                setState(() {
                  step = 2;
                });
              },
              text: "Verify",
            ),
          ),
        ],
      ),
    );
  }

  Widget step2() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Enter the code that was sent to : $_phoneNumber',
            style: TextStyle(
              fontFamily: "PrimaryFont",
              fontSize: 22,
            ),
          ),
          CenterWidget(
            child: Center(
              child: Container(
                width: 100,
                child: TextFormField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: _smsController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "_ _ _ _ _ _",
                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: ButtonWidget(
              onPressed: () {
                authService.signInWithPhoneNumber(_smsController.text);
              },
              text: "Sign In",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageHeaderWidget(title: "signin"),
          step == 1 ? step1() : step2(),
        ],
      ),
    );
  }
}
