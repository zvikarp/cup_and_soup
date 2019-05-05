import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:cup_and_soup/widgets/core/snackbar.dart';

class FirebaseMessagingService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void getUsersTocken() {
    _firebaseMessaging.getToken().then((token) {
      
    });
  }

  void firebaseCloudMessagingListeners(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        String title = message['notification']['title'];
        String body = message['notification']['body'];
        SnackbarWidget.messsageBar(context, title, body);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
}

final FirebaseMessagingService firebaseMessagingService =
    FirebaseMessagingService();
