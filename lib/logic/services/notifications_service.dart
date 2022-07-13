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
                    color: Color(0xff4CB469),
                    icon: '@drawable/ic_abrabar_note')));
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
}
