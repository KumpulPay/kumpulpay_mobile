import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/firebase_options.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/repository/sqlite/notification_dao.dart';
import 'package:kumpulpay/repository/sqlite/notification_entity.dart';
import 'package:kumpulpay/main.dart';

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************

class NotificationController extends ChangeNotifier {
  /// *********************************************
  ///   SINGLETON PATTERN
  /// *********************************************

  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  Future<void> init() async {
    await initializeLocalNotifications();
    await initializeRemoteNotifications(debug: true);
    await initializeIsolateReceivePort();
    await startListeningNotificationEvents();
  }

  /// *********************************************
  ///  OBSERVER PATTERN
  /// *********************************************

  String _firebaseToken = '';
  String get firebaseToken => _firebaseToken;

  String _nativeToken = '';
  String get nativeToken => _nativeToken;

  ReceivedAction? initialAction;
  static ReceivePort? receivePort;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    // print('print initializeLocalNotifications');
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    _instance.initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    // print('print initializeRemoteNotifications');
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    final FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance;
    firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    firebaseMessaging.getToken().then((token) {
      SharedPrefs().fcmTokenMobile = token.toString();
      // print("Firebase Messaging Token: $token");
    });
  
    await AwesomeNotificationsFcm().initialize(
        onFcmTokenHandle: NotificationController.myFcmTokenHandle,
        onNativeTokenHandle: NotificationController.myNativeTokenHandle,
        onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
        licenseKeys: null,
        debug: debug);
  }

  static Future<void> initializeIsolateReceivePort() async {
    print('print initializeIsolateReceivePort');
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    print('print startListeningNotificationEvents');
    AwesomeNotifications()
        .setListeners(
          onActionReceivedMethod: onActionReceivedMethod,
          onNotificationCreatedMethod: onNotificationCreatedMethod,
          onNotificationDisplayedMethod: onNotificationDisplayedMethod,
          onDismissActionReceivedMethod: onDismissActionReceivedMethod
        );
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************

  static Future<void> getInitialNotificationAction() async {
    print('print getInitialNotificationAction');
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;

    Fluttertoast.showToast(
        msg: 'Notification action launched app: $receivedAction',
      backgroundColor: Colors.deepPurple
    );
    // print('App launched by a notification action: $receivedAction');
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {

    Map<String, String?>? payload = receivedAction.payload;    
    print('print onActionReceivedMethod $payload');
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      // print('Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {
        // print('onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
            IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          // print('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
      print('onNotificationCreatedMethod ${receivedNotification.toString()}');
      await _storeNotification(receivedNotification);
  }
  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
        print('onNotificationDisplayedMethod ${receivedNotification.toString()}');
  }
  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
        print('onDismissActionReceivedMethod ${receivedNotification.toString()}');
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    print('print onActionReceivedImplementationMethod $receivedAction');
   
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification',
        (route) =>
            (route.settings.name != '/notification') || route.isFirst,
        arguments: receivedAction);
  }

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    print('print mySilentDataHandle  ${silentData.toString()}');
    Fluttertoast.showToast(
        msg: 'Silent data received',
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16);

    // print('print mySilentDataHandle');
    // print('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print("bg");
    } else {
      print("FOREGROUND");
    }

    // print('mySilentDataHandle received a FcmSilentData execution');
    await executeLongTaskInBackground();
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    print('print myFcmTokenHandle');
    if (token.isNotEmpty) {
      sendTokenFcmToServer(token);

      Fluttertoast.showToast(
          msg: 'Fcm token received',
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16);

      debugPrint('Firebase Token:"$token"');
    } else {
      Fluttertoast.showToast(
          msg: 'Fcm token deleted',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16);

      debugPrint('Firebase Token deleted');
    }

    _instance._firebaseToken = token;
    _instance.notifyListeners();
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    print('print myNativeTokenHandle');
    Fluttertoast.showToast(
        msg: 'Native token received',
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16);
    debugPrint('Native Token:"$token"');

    _instance._nativeToken = token;
    _instance.notifyListeners();
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale(BuildContext context) async {
    bool userAuthorized = false;
    // BuildContext context = _context;
    // BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("print executeLongTaskInBackground");
    // print("starting long task");
    // await Future.delayed(const Duration(seconds: 4));
    // final url = Uri.parse("http://google.com");
    // final re = await http.get(url);
    // print(re.body);
    // print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification(BuildContext context) async {
    // print('print createNewNotification');
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale(context);
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> scheduleNewNotification(BuildContext context) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale(context);
    if (!isAllowed) return;

    await myNotifyScheduleInHours(
        title: 'test',
        msg: 'test message',
        heroThumbUrl:
            'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
        hoursFromNow: 5,
        username: 'test user',
        repeatNotif: false);
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  ///  *********************************************
  ///     REMOTE TOKEN REQUESTS
  ///  *********************************************

  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        return await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }
  

  static Future<void> _storeNotification(ReceivedNotification received) async {
    Map<String, dynamic> payload = received.payload??{};
    // print('xx: ${payload['type']}');
    print('simpan notid');
    final notificationEntity = NotificationEntity.optional(
      type: payload['type'],
      title: received.title,
      subtitle: received.body,
      image: received.bigPicture,
      data: received.payload.toString(),
    );
    try {
      final NotificationDao dao = GetIt.instance.get<NotificationDao>();
      await dao.insertData(notificationEntity);
    } catch (e) {
      print('Error _storeNotification: $e');
    }
  }
}

Future<void> myNotifyScheduleInHours({
  required int hoursFromNow,
  required String heroThumbUrl,
  required String username,
  required String title,
  required String msg,
  bool repeatNotif = false,
}) async {
  var nowDate = DateTime.now().add(Duration(hours: hoursFromNow, seconds: 5));
  await AwesomeNotifications().createNotification(
    schedule: NotificationCalendar(
      //weekday: nowDate.day,
      hour: nowDate.hour,
      minute: 0,
      second: nowDate.second,
      repeats: repeatNotif,
      //allowWhileIdle: true,
    ),
    // schedule: NotificationCalendar.fromDate(
    //    date: DateTime.now().add(const Duration(seconds: 10))),
    content: NotificationContent(
      id: -1,
      channelKey: 'basic_channel',
      title: '${Emojis.food_bowl_with_spoon} $title',
      body: '$username, $msg',
      bigPicture: heroThumbUrl,
      notificationLayout: NotificationLayout.BigPicture,
      //actionType : ActionType.DismissAction,
      color: Colors.black,
      backgroundColor: Colors.black,
      // customSound: 'resource://raw/notif',
      payload: {'actPag': 'myAct', 'actType': 'food', 'username': username},
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'NOW',
        label: 'btnAct1',
      ),
      NotificationActionButton(
        key: 'LATER',
        label: 'btnAct2',
      ),
    ],
  );
}

Future<void> sendTokenFcmToServer(String token) async {
  try {

    if (SharedPrefs().token == '') {
        return;
    }
    Map<String, dynamic> body = {"fcm_token_mobile": token};
    String jsonString = json.encode(body);

    final client = ApiClient(AppConfig().configDio());
    final post = await client.postUpdateFcm(
        authorization: 'Bearer ${SharedPrefs().token}', body: jsonString);

    if (!post.success) {
        Fluttertoast.showToast(
            msg: 'Fcm token gagal di update!',
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16);
    }

  } on DioException catch (e) {
    rethrow;
  }
}
