// Random use karne ke liye (channel id generate karne me)
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {

  // Firebase messaging instance
  FirebaseMessaging message = FirebaseMessaging.instance;

  // local msg ko show krne k liye (Flutter local notification plugin)
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // fun. bnye h , lecture 4 explaiantion
  void requestNotificationPermission() async {

    // user se notification permission mangta hai
    NotificationSettings settings = await message.requestPermission(

      // esse device pe notification show hoga
      alert: true,

      // notification read krne k liye
      announcement: true,

      // kis app se notification aaya uska icons show krega
      badge: true,

      carPlay: true,
      criticalAlert: true,

      // eske help se pusega ki notification ko allow krn ah ya nhi
      provisional: true,

      sound: true,
    );

    // now condition lgayenge ki kb ky krna h
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    }
    else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('user granted provisional permission');
    }
    else {
      print('user denied permission');
    }
  }

  // lecture 5 related to token
  // future fun bnayenge
  Future<String> getDeviceToken() async {
    String? token = await message.getToken();
    return token!;
  }

  // locsl msg ko show krne k liye fu. bn rhe h
  void initLocalNotification(BuildContext context, ) async {

    // for android icon (app icon use hoga)
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    // for ios initialization
    var iosInitializationSettings = const DarwinInitializationSettings();

    // dono platform ka combined initialization
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // plugin initialize
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        // jab user notification pe click kare
      },
    );
  }

  // lecture 6 , fun. bny h jikse help se app active rhne pe notification show hoga
  void firebaseInit() {

    // foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if (kDebugMode) {
        // debug me title aur body print karega
        print(message.notification?.title.toString());
        print(message.notification?.body.toString());
      }

      // foreground me local notification show karne ke liye
      showNotification(message);
    });
  }

  // notofication show krne k liye local plugin se
  Future<void> showNotification(RemoteMessage message) async {

    // random id ke sath channel create (Android ke liye)
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'high_importance_channel', // channel name
      importance: Importance.max,
    );

    // Android notification details
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // iOS notification details
    const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // combined notification details
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // notification show (foreground me)
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        id: 0,
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        notificationDetails: notificationDetails,
      );
    });
  }

  // check krenge ki token expire hua ya nhh , agr expire ho jayega to new token generate kr dega
  void isTokenRefresh() async {
    message.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }
}