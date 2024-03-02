import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kumpulpay_mobile/intro.dart';
import 'data/my_colors.dart';
import 'data/sqlite_db.dart';
import 'data/img.dart';
import 'widget/my_text.dart';
import 'dart:developer';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
      theme: ThemeData(
          primaryColor: MyColors.primary,
          primaryColorDark: MyColors.primaryDark,
          primaryColorLight: MyColors.primaryLight,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent)),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/IntroRoute': (BuildContext context) => new IntroRoute(),
        // '/About': (BuildContext context) => new AboutAppRoute(),
      }
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/IntroRoute');
  }

  @override
  void initState() {
    super.initState();
    SQLiteDb dbHelper = SQLiteDb();
    dbHelper.init();

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          // width: 105,
          // height: 150,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 100, height: 100,
                child: Image.asset(Img.get('kumpulpay_logo.webp'), fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text("KumpulPay", style: MyText.headline(context)!.copyWith(
                color: Colors.grey[800], fontWeight: FontWeight.w600
              )),
              Text("Flutter Version", style: MyText.body1(context)!.copyWith(color: Colors.grey[500])),
              SizedBox(height: 20),
              Container(
                height: 5,
                width: 80,
                child: LinearProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(MyColors.primaryLight),
                  backgroundColor: Colors.grey[300],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}


