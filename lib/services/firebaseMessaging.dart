import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:cup_and_soup/services/sharedPreferences.dart';
import 'package:cup_and_soup/services/cloudFunctions.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';

class FirebaseMessagingService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void getUsersTocken() {
    _firebaseMessaging.getToken().then((String fcmToken) async {
      String currentFcmToken = await sharedPreferencesService.getFcmToken();
      if (fcmToken != currentFcmToken) {
        List<String> topicsList = await sharedPreferencesService.getNtifications();
        updateUserNotificationsTopics(topicsList, topicsList);
        sharedPreferencesService.setFcmToken(fcmToken);
        cloudFunctionsService.changeFcmToken(fcmToken);
      }
    });
  }

  bool updateUserNotificationsTopics(List<String> topicsToSubscribe, List<String> allTopics) {
    allTopics.forEach((topic) {
      if (topicsToSubscribe.contains(topic))
        _firebaseMessaging.subscribeToTopic(topic);
      else
        _firebaseMessaging.unsubscribeFromTopic(topic);
    });
    return true;
  }

  void firebaseCloudMessagingListeners(BuildContext context) {
    getUsersTocken();

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
