import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications {
  final int _rndId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

  void subscribeToNotes() async {
    await FirebaseMessaging.instance.subscribeToTopic("test");
    String? token = await FirebaseMessaging.instance.getToken();
    print('TOKEN IS: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      log(message.notification.toString());
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              wakeUpScreen: true,
              id: _rndId,
              channelKey: "basic_key",
              title: 'ну, это тайтл пуша? ${message.data['title']}',
              body: message.data['body']));
    });
  }

  void onBackGroundNotification(RemoteMessage message) async {
    await Firebase.initializeApp();
    // print(message.)
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: _rndId,
            wakeUpScreen: true,
            channelKey: "basic_key",
            title: 'пуш через жопу ${message.data['title']}',
            body: message.data['body']));
  }
}
