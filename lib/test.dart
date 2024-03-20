import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  const Test({Key? key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

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

  List bankname = [
    "Citibank",
    "Bank of America",
    "usbank",
    "Barclays Bank",
    "HSBC India",
    "Deutsche Bank",
    "DBS Bank"
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          "Test",
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: Center(
          child: InkWell(
            onTap: () {
              // Handle onTap action here
              print('Widget clicked!');
            },
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)], // Add shadow effect here
              ),
              child: Center(
                child: Text(
                  'Click Me',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          )
      )
    );

  }
}