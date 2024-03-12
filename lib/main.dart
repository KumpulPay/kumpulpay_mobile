import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:kumpulpay/splashscreen.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:provider/provider.dart';

FutureOr<void> main() async {
  // runApp(const App());
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