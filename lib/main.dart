import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'app.dart';
import 'package:kumpulpay/splashscreen.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:provider/provider.dart';

FutureOr<void> main() async {
  // runApp(const App());
 WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  // final sharedPrefs = SharedPref();
  // await SharedPrefs.init();
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