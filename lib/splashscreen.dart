import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'onbonding.dart';

class Splashscreen extends StatefulWidget {
  static String routeName = '/main';
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late ColorNotifire notifire;


  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  getInit() async {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushNamedAndRemoveUntil(
                          context, Onbonding.routeName, (route) => false),
    );
  }

  @override
  void initState() {
    super.initState();
    // getdarkmodepreviousstate();
    getInit();
   
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          // width: 105,
          // height: 150,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 100, height: 100,
                child: Image.asset('images/kumpulpay_logo.webp', fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text("KumpulPay",  style: TextStyle(
                        fontSize: height / 30,
                        fontFamily: 'Gilroy Bold',
                        color: notifire.getdarkscolor)),
              const SizedBox(height: 20),
              SizedBox(
                height: 5,
                width: 80,
                child: LinearProgressIndicator(
                  valueColor:
                      const AlwaysStoppedAnimation<Color>( Color(0xff6C56F9)),
                  backgroundColor: Colors.grey[300],
                ),
              )

            ],
          ),
        ),
      )
      
      // Column(
      //   children: [
      //     Stack(
      //       children: [
      //         Container(
      //           color: Colors.transparent,
      //           height: height,
      //           width: width,
      //           child: Image.asset(
      //             "images/splash.png",
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //         Column(
      //           children: [
      //             SizedBox(
      //               height: height / 2.4,
      //             ),
      //             Center(
      //               child: Image.asset(
      //                 "images/logo_app/ic_launcher_round.webp",
      //                 height: height / 7,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
