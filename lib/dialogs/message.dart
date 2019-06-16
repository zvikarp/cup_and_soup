import 'package:cup_and_soup/utils/localizations.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/dialog.dart';
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
          return translate.text("mag:d-gs0");
        case 'ge0':
          return translate.text("mag:d-ge0");
        case 'ge1':
          return translate.text("mag:d-ge1");
        case 'ge2':
          return translate.text("mag:d-ge2");
        case 'ge3':
          return translate.text("mag:d-ge3");
        case 'ge4':
          return translate.text("mag:d-ge4");
        default:
          return translate.text("mag:d-geUnknown");
      }
    } else if (collection == 'b') {
      switch (responseCode) {
        case 'b-gs0':
          return translate.text("mag:d-b-gs0");
        case 'b-ge0':
        case 'b-ge1':
        case 'b-ge2':
        case 'b-ge3':
        case 'b-ge4':
          return _textMessage(code);
        case 'b-e0':
          return translate.text("mag:d-b-e0");
        case 'b-e1':
          return translate.text("mag:d-b-e1");
        case 'b-e2':
          return translate.text("mag:d-b-e2");
        default:
          return _textMessage("g");
      }
    } else if (collection == 'm') {
      switch (responseCode) {
        case 'm-gs0':
          return translate.text("mag:d-m-gs0");
        case 'm-ge0':
        case 'm-ge1':
        case 'm-ge2':
        case 'm-ge3':
        case 'm-ge4':
          return _textMessage(code);
        case 'm-e0':
          return translate.text("mag:d-m-e0");
        case 'm-e1':
          return translate.text("mag:d-m-e1");
        case 'm-e2':
          return translate.text("mag:d-m-e2");
        default:
          return _textMessage("g");
      }
    } else if (collection == 'd') {
      switch (responseCode) {
        case 'd-gs0':
          return translate.text("mag:d-d-gs0");
        case 'd-ge0':
        case 'd-ge1':
        case 'd-ge2':
        case 'd-ge3':
        case 'd-ge4':
          return _textMessage(code);
        case 'd-e0':
          return translate.text("mag:d-d-e0");
        case 'd-e1':
          return translate.text("mag:d-d-e1");
        case 'd-e2':
          return translate.text("mag:d-d-e2");
        default:
          return _textMessage("g");
      }
    } else if (collection == 'c') {
      switch (responseCode) {
        case 'c-gs0':
          return translate.text("mag:d-c-gs0");
        case 'c-ge0':
        case 'c-ge1':
        case 'c-ge2':
        case 'c-ge3':
        case 'c-ge4':
          return _textMessage(code);
        case 'c-e0':
          return translate.text("mag:d-c-e0");
        case 'c-e1':
          return translate.text("mag:d-c-e1");
        default:
          return _textMessage("g");
      }
    } else if (collection == 's') {
      switch (responseCode) {
        case 's-ge0':
          return _textMessage(code);
        case 's-e0':
          return translate.text("mag:d-s-e0");
        case 's-e1':
          return translate.text("mag:d-s-e1");
        case 's-e2':
          return translate.text("mag:d-s-e2");
        default:
          return _textMessage("g");
      }
    } else {
      _textMessage("g");
    }
    return "FALSE";
  }

  Widget _actionSection(BuildContext context, String type) {
    String buttonText = translate.text("button-back");
    if (type == 's') buttonText = "OK";
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ButtonWidget(
        text: buttonText,
        onPressed: () => Navigator.pop(context),
        primary: false,
      ),
    );
  }

  String _title(String title) {
    if (title == "e") return translate.text("mag:d-error-t");
    else if (title == "s") return translate.text("mag:d-success-t");
    else return translate.text("mag:d-unknown-t");
  }

  @override
  Widget build(BuildContext context) {
    String type = responseCode.split("-").last.replaceFirst('g', '')[0];
    String title = responseCode.replaceAll(RegExp(r'([0-9])'), "");
    title = title[title.length-1];
    return DialogWidget(
      heading: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              _title(title),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24),
          child: _icon(type),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Text(
            _textMessage(responseCode),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    actionSection: _actionSection(context, type),
    );
  }
}
