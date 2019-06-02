import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/services/sharedPreferences.dart';
import 'package:cup_and_soup/services/cloudFunctions.dart';
import 'package:cup_and_soup/models/user.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';

class FirebaseMessagingService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void getUsersToken() {
    _firebaseMessaging.getToken().then((String fcmToken) async {
      User user = await cloudFirestoreService.streamUserData().first;
      String currentFcmToken = user.fcmToken;
      if (fcmToken != currentFcmToken) {
        List<String> topicsList =
            await sharedPreferencesService.getNtifications();
        updateUserNotificationsTopics(topicsList, topicsList);
        sharedPreferencesService.setFcmToken(fcmToken);
        cloudFunctionsService.changeFcmToken(fcmToken);
        if (user.roles.contains("admin"))
          cloudFirestoreService.updateAdminFcmToken(fcmToken);
      }
    });
  }

  bool updateUserNotificationsTopics(
      List<String> topicsToSubscribe, List<String> allTopics) {
    allTopics.forEach((topic) {
      if (topicsToSubscribe.contains(topic))
        _firebaseMessaging.subscribeToTopic(topic);
      else
        _firebaseMessaging.unsubscribeFromTopic(topic);
    });
    return true;
  }

  void firebaseCloudMessagingListeners(BuildContext context) {
    getUsersToken();

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
