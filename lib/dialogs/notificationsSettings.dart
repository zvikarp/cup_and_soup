import 'package:cup_and_soup/models/user.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFunctions.dart';
import 'package:cup_and_soup/services/firebaseMessaging.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class NotificationsSettingsDialog extends StatefulWidget {
  NotificationsSettingsDialog({
    @required this.user,
  });

  final User user;

  @override
  _NotificationsSettingsDialogState createState() =>
      _NotificationsSettingsDialogState();
}

class _NotificationsSettingsDialogState
    extends State<NotificationsSettingsDialog> {
  final List<Map<String, String>> _notificatinTypes = [
    {
      "topic": "important",
      "desc": "Receive important notifications",
    },
    {
      "topic": "general",
      "desc": "Receive general notifications",
    },
    {
      "topic": "special",
      "desc": "Receive special discounts and sales notifications",
    },
  ];

  List<String> _userNotificationsSettings = [];
  String _save = "SAVE";

  Future<bool> _updateNotificationSettings() async {
    print(_userNotificationsSettings);
    print(widget.user.notifications);
    if (_userNotificationsSettings != widget.user.notifications) {
      setState(() {
        _save = "SAVING...";
      });
      List<String> allTopics =
          _notificatinTypes.map((topic) => topic['topic']).toList();
      firebaseMessagingService.updateUserNotificationsTopics(
          _userNotificationsSettings, allTopics);
      await cloudFunctionsService.changeNotifications(_userNotificationsSettings);
      setState(() {
        _save = "SAVED";
      });
    }
    Navigator.pop(context, true);

    return true;
  }

  @override
  void initState() {
    super.initState();
    List<String> userNotifications = widget.user.notifications ?? [];
    setState(() {
      _userNotificationsSettings = userNotifications.toList();
    });
  }

  Widget _actionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ButtonWidget(
            text: "CLOSE",
            onPressed: () => Navigator.pop(context, false),
            primary: false,
          ),
          ButtonWidget(
            text: _save,
            onPressed: _updateNotificationSettings,
          ),
        ],
      ),
    );
  }

  TableRow _notificationRow(
      BuildContext context, Map<String, String> notification) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          notification['desc'],
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      Switch(
        value: _userNotificationsSettings.contains(notification['topic']),
        onChanged: (v) async {
          if (_userNotificationsSettings.contains(notification['topic'])) {
            setState(() {
              _userNotificationsSettings.remove(notification['topic']);
            });
          } else {
            setState(() {
              _userNotificationsSettings.add(notification['topic']);
            });
          }
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ]);
  }

  Widget _content(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {0: FractionColumnWidth(.7)},
      children:
          _notificatinTypes.map((n) => _notificationRow(context, n)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      scrollable: true,
      heading: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Notification Settings",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24),
            child: _content(context),
          ),
        ],
      ),
      actionSection: Padding(
        padding: const EdgeInsets.all(16),
        child: _actionSection(context),
      ),
    );
  }
}
