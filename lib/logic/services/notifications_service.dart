import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  final int _rndId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

  void subscribeToNotes(FlutterLocalNotificationsPlugin flnPlugin,
      AndroidNotificationChannel channel) async {
    //   await FirebaseMessaging.instance.subscribeToTopic("test");
    String? token = await FirebaseMessaging.instance.getToken();
    print('TOKEN IS: $token');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? note = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (note != null && android != null) {
        flnPlugin.show(
            _rndId,
            note.title,
            note.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    color: Colors.pink, icon: '@mipmap/ic_launcher')));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? note = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (note != null && android != null) {
        log('APP WAS OPENED BY PRESSING NOTE $note');
      }
    });
  }

  // void onBackGroundNotification(RemoteMessage message) async {
  //   await Firebase.initializeApp();
  //   // print(message.)
  //   await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: _rndId,
  //           wakeUpScreen: true,
  //           channelKey: "basic_key",
  //           title: 'пуш через жопу ${message.data['title']}',
  //           body: message.data['body']));
  // }
}
