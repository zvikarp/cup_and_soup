import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cup_and_soup/services/sharedPreferences.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/widgets/core/table.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:cup_and_soup/pages/splash.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({
    @required this.uid,
    @required this.userData,
  });

  final String uid;
  final Map<String, dynamic> userData;

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  TextEditingController nameCtr = TextEditingController();
  String _name = "";
  String _newName = "";
  bool _loading = false;

  Map<String, String> _langs = {'en': 'English', 'he': 'עברית'};
  String _selectedLang = "";

  void _getLang() async {
    String lang = await sharedPreferencesService.getLang();
    setState(() {
     _selectedLang = lang ?? _langs.keys.toList().first; 
    });
  }

  @override
  void initState() {
    super.initState();
    _getLang();
    setState(() {
      nameCtr.text = widget.userData["name"];
      _name = widget.userData["name"];
      _newName = widget.userData["name"];
    });
  }

  void _nameChangeRequest() async {
    setState(() {
      _loading = true;
    });
    bool res = await authService.changeName(_newName);
    if (res)
      SnackbarWidget.successBar(
          context, "Your name hase been updated successfully.");
    else
      SnackbarWidget.errorBar(context, "Error updating your name.");
    setState(() {
      _loading = false;
      _name = _newName;
    });
  }

  List<Widget> _nameRow() {
    return [
      Text(
        "Name: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: nameCtr,
              style: TextStyle(
                fontFamily: "PrimaryFont",
                fontSize: 18,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                hintText: "Your awesome name",
              ),
              onChanged: (string) {
                setState(() {
                  _newName = string;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _loading
                ? Icon(Icons.rotate_right)
                : _newName != _name
                    ? GestureDetector(
                        onTap: _nameChangeRequest,
                        child: Icon(Icons.refresh),
                      )
                    : Container(),
          ),
        ],
      ),
    ];
  }

  List<Widget> _emailRow() {
    return [
      Text(
        "Email: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(widget.userData["email"]),
    ];
  }

  List<Widget> _rolesRow() {
    return widget.userData["roles"].join() != "customer"
        ? [
            Text(
              "Roles: ",
              style: TextStyle(
                fontFamily: "PrimaryFont",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.userData["roles"].join(", ")),
          ]
        : [Container()];
  }

  void _setLang(String lang) async {
    await sharedPreferencesService.setLang(lang);
    setState(() {
      _selectedLang = lang;
    });
    SnackbarWidget.infoBar(
        context, "Please reload the app for your settings to take effect.");
  }

  Widget _langButton(lang, selected) {
    return GestureDetector(
      onTap: () => _setLang(lang),
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: selected
            ? EdgeInsets.only(left: 8, right: 8, bottom: 2)
            : EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          _langs[lang],
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
            color: selected ? Colors.grey[200] : Colors.black,
          ),
        ),
      ),
    );
  }

  List<Widget> _langRow() {
    return [
      Text(
        "Language: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        children: _langs.keys.toList()
            .map((lang) => _langButton(lang, lang == _selectedLang))
            .toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            "Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PrimaryFont",
              fontSize: 24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TableWidget(
            headings: [" ", " "],
            flex: [1, 2],
            items: [
              _nameRow(),
              _emailRow(),
              _rolesRow(),
              _langRow(),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: ButtonWidget(
                text: "Sign Out",
                onPressed: () {
                  authService.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SplashPage()));
                },
                primary: false,
                size: "small",
              ),
            )),
      ],
    );
  }
}
