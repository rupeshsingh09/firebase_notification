import 'package:firebase_notification/notification_services.dart';
import 'package:flutter/material.dart';
// 🔥 add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override

  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // jo class bnye te usko call kiye h jiske help se notification aayega
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

    // notification permission ke liye
    notificationServices.requestNotificationPermission();

    // 🔥 local notification initialize (IMPORTANT)
    // RemoteMessage empty create kar rahe hain kyuki function me parameter hai
    notificationServices.initLocalNotification(context);

    // active app rhne pe notification show krega usi fun. ko call kr rhe h
    notificationServices.firebaseInit();

    // fun. call kiye h jo ki ckeck krega token expire hua ya nhh
    notificationServices.isTokenRefresh();

    // jo fun. bnye h usko call krenge token ko get krne k liye
    notificationServices.getDeviceToken().then((value) {
      print('device token');
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home Screen"),
      ),
    );
  }
}