import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class MessageDialog extends StatelessWidget {
  MessageDialog({
    @required this.responseCode,
  });

  final String responseCode;

  Widget _icon(String type) {
    if (type == 's')
      return Icon(Icons.check);
    else if (type == 'e')
      return Icon(Icons.error_outline);
    else
      return Icon(Icons.warning);
  }

  String _textMessage(String responseCode) {
    String code = responseCode.split('-').last;
    String collection = responseCode[0];
    if (collection == 'g') {
      switch (responseCode) {
        case 'gs0':
          return "The operation was successfull.";
        case 'ge0':
          return "Oops... Something unexpected happened, please try again later.";
        case 'ge1':
          return "Error connecting to network, please check your internet connection.";
        case 'ge2':
          return "We are sorry, we are unable to connect to our servers right now, please try again later.";
        case 'ge3':
          return "The request use-by date has expierd.";
        case 'ge4':
          return "Can not sign in with the current user id, please try restarting the app.";
        default:
          return "An unknown error occured, we would be able to help me if you leave us some feadback.";
      }
    } else if (collection == 'b') {
      switch (responseCode) {
        case 'b-gs0':
          return "Enjoy your soup!.";
        case 'b-ge0':
        case 'b-ge1':
        case 'b-ge2':
        case 'b-ge3':
        case 'b-ge4':
          return _textMessage(code);
        case 'b-e0':
          return "We are sorry, currently this item is out of stock. We are trying are best to get it back to you!";
        case 'b-e1':
          return "Ouch. It seems like you don't have enough money to my this. You might want to add money to your account.";
        case 'b-e2':
          return "The requested item doesn't exist in the store, please try selecting a differant item.";
        default:
          return _textMessage("g");
      }
    } else if (collection == 'm') {
      switch (responseCode) {
        case 'm-gs0':
          return "The money was successfully transfered to your account!";
        case 'm-ge0':
        case 'm-ge1':
        case 'm-ge2':
        case 'm-ge3':
        case 'm-ge4':
          return _textMessage(code);
        case 'm-e0':
          return "The scanned code doesn't exist anymore.";
        case 'm-e1':
          return "It looks like you have successfully used the code already. It can't be used twice.";
        case 'm-e2':
          return "The barcode has expired.";
        default:
          return _textMessage("g");
      }
    } else if (collection == 'd') {
      switch (responseCode) {
        case 'd-gs0':
          return "The discount was successfully applied to your account!";
        case 'd-ge0':
        case 'd-ge1':
        case 'd-ge2':
        case 'd-ge3':
        case 'd-ge4':
          return _textMessage(code);
        case 'd-e0':
          return "The scanned code doesn't exist anymore.";
        case 'd-e1':
          return "It looks like you have successfully used the code already. It can't be used twice.";
        case 'd-e2':
          return "The barcode has expired.";
        default:
          return _textMessage("g");
      }
    } else if (collection == 'c') {
      switch (responseCode) {
        case 'c-gs0':
          return "The credit update was successfully applied account!";
        case 'c-ge0':
        case 'c-ge1':
        case 'c-ge2':
        case 'c-ge3':
        case 'c-ge4':
          return _textMessage(code);
        case 'c-e0':
          return "The scanned code doesn't exist anymore.";
        case 'c-e1':
          return "The barcode has expired.";
        default:
          return _textMessage("g");
      }
    } else if (collection == 's') {
      switch (responseCode) {
        case 's-ge0':
          return _textMessage(code);
        case 's-e0':
          return "There is a problem recognising the barcode, please make your you are in a light place.";
        case 's-e1':
          return "Please enable camera permissions so you can use the scanner.";
        case 's-e2':
          return "Umm... It looks like this barcode dosn't exist.";
        default:
          return _textMessage("g");
      }
    } else {
      _textMessage("g");
    }
    return "FALSE";
  }

  Widget _actionSection(BuildContext context, String type) {
    String buttonText = "BACK";
    if (type == 's') buttonText = "OK";
    return ButtonWidget(
      text: buttonText,
      onPressed: () => Navigator.pop(context),
      primary: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String type = responseCode.split("-").last.replaceFirst('g', '')[0];
    return DialogWidget(
        child: Column(
      children: <Widget>[
        _icon(type),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Text(
            _textMessage(responseCode),
            textAlign: TextAlign.center,
          ),
        ),
        DividerWidget(),
        _actionSection(context, type),
      ],
    ));
  }
}
