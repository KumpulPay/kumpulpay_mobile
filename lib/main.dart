import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/notification/notification_controller.dart';
import 'package:kumpulpay/repository/sqlite/database_provider.dart';
import 'package:kumpulpay/splashscreen.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:provider/provider.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseProvider.initialize();
    await SharedPrefs().init();
    await NotificationController().init();
  } catch (e) {
    print('error main init: $e');
  }
  

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