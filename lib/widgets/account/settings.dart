import 'package:cup_and_soup/dialogs/notificationsSettings.dart';
import 'package:cup_and_soup/utils/themes.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/services/cloudFunctions.dart';
import 'package:cup_and_soup/utils/localizations.dart';
import 'package:cup_and_soup/models/user.dart';
import 'package:cup_and_soup/pages/splash.dart';
import 'package:cup_and_soup/widgets/core/table.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({
    @required this.user,
  });

  final User user;

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  TextEditingController nameCtr = TextEditingController();
  String _name = "";
  String _newName = "";
  bool _loading = false;

  Map<String, String> _langs = {'en': 'English', 'he': 'עברית'};
  List<String> _modes = ['light', 'dark'];
  String _selectedLang = "";
  String _selectedMode = "light";

  void _getSetting() async {
    String lang = await translate.getPreferredLanguage();
    String mode = await themes.getPreferredTheme();
    setState(() {
      _selectedLang = lang ?? _langs.keys.toList().first;
      _selectedMode = mode ?? _modes.toList().first;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSetting();
    setState(() {
      nameCtr.text = widget.user.name;
      _name = widget.user.name;
      _newName = widget.user.name;
    });
  }

  void _nameChangeRequest() async {
    setState(() {
      _loading = true;
    });
    bool res = await cloudFunctionsService.changeName(_newName);
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
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          translate.text("field-name") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: nameCtr,
              style: Theme.of(context).textTheme.body1,
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
          _loading
              ? Icon(Icons.rotate_right)
              : _newName != _name
                  ? Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: _nameChangeRequest,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(Icons.save),
                          ),
                        ),
                      ],
                    )
                  : Container(width: 16),
        ],
      ),
    ];
  }

  List<Widget> _emailRow() {
    return [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          translate.text("field-email") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(widget.user.email),
    ];
  }

  List<Widget> _notificationsRow() {
    return [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          translate.text("field-notifications") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Text(
              translate.text("acc:p-settings:w-notifications"),
              style: Theme.of(context).textTheme.subtitle,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                TransparentRoute(
                  builder: (BuildContext context) =>
                      NotificationsSettingsDialog(user: widget.user),
                ),
              );
            },
            child: Container(
              width: 42,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black,
              ),
              child: Icon(
                Icons.navigate_next,
                size: 16,
                color: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _rolesRow() {
    if (widget.user.roles.join() != "customer") {
      List<String> roles = widget.user.roles;
      Map<String, String> translatedRoles = translate.text("roles-types");
      List<String> translatedUserRoles = [];
      for (String role in roles) {
        translatedUserRoles.add(translatedRoles[role]);
      }
      return [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            translate.text("field-roles") + ": ",
            style: Theme.of(context).textTheme.body2,
          ),
        ),
        Text(translatedUserRoles.join(", ")),
      ];
    } else
      return [Container()];
  }

  void _setLang(String lang) async {
    translate.setNewLanguage(lang);
    setState(() {
      _selectedLang = lang;
    });
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
          style: Theme.of(context).textTheme.body1.merge(
                TextStyle(
                  color: selected ? Colors.grey[200] : themes.load("body2"),
                ),
              ),
        ),
      ),
    );
  }

  void _setTheme(String theme) async {
    themes.setNewTheme(theme);
    setState(() {
      _selectedMode = theme;
    });
  }

  Widget _modeButton(mode, selected) {
    return GestureDetector(
      onTap: () => _setTheme(mode),
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
          translate.text("acc:p-settings:w-viewMode")[mode],
          style: Theme.of(context).textTheme.body1.merge(
                TextStyle(
                  color: selected ? Colors.grey[200] : themes.load("body2"),
                ),
              ),
        ),
      ),
    );
  }

  List<Widget> _langRow() {
    return [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          translate.text("field-language") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Row(
        children: _langs.keys
            .toList()
            .map((lang) => _langButton(lang, lang == _selectedLang))
            .toList(),
      ),
    ];
  }

  List<Widget> _viewModeRow() {
    return [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          translate.text("field-viewMode") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Row(
        children: _modes
            .toList()
            .map((mode) => _modeButton(mode, mode == _selectedMode))
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
            translate.text("acc:p-settings:w-t"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TableWidget(
            headings: [" ", " "],
            flex: [.4, .6],
            items: [
              _nameRow(),
              _emailRow(),
              _notificationsRow(),
              _rolesRow(),
              _langRow(),
              _viewModeRow(),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonWidget(
                  text: translate.text("acc:p-settings:w-signOut-b"),
                  onPressed: () {
                    authService.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SplashPage()));
                  },
                  primary: false,
                ),
                ButtonWidget(
                  text: translate.text("acc:p-settings:w-deleteAccount-b"),
                  disabled: true,
                  onPressed: () {
                    SnackbarWidget.infoBar(
                        context, "This feature is still under develepment.");
                  },
                  primary: false,
                ),
              ],
            )),
      ],
    );
  }
}
