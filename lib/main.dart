import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/notification/notification_controller.dart';
import 'package:kumpulpay/splashscreen.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:provider/provider.dart';

FutureOr<void> main() async {
 
  // WidgetsFlutterBinding.ensureInitialized();
  // await SharedPrefs().init();
  // await AwesomeNotifications().requestPermissionToSendNotifications();
  // await NotificationController.initializeLocalNotifications();
  // await NotificationController.initializeRemoteNotifications(debug: true);
  // await NotificationController.initializeIsolateReceivePort();
  // await NotificationController.startListeningNotificationEvents();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ColorNotifire(),
        ),
      ],
      child: const MaterialApp(
        home: Splashscreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}