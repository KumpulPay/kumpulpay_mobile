import 'package:flutter/material.dart';
import 'package:kumpulpay/security/password/password_change.dart';
import 'package:kumpulpay/security/password/password_forgot.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  static String routeName = '/security/password';
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: notifire.getprimerycolor,
          elevation: 0,
          iconTheme: IconThemeData(color: notifire.getdarkscolor),
          centerTitle: false,
          title: Text(
            "Password",
            style: TextStyle(
              color: notifire.getdarkscolor,
              fontFamily: 'Gilroy Bold',
              fontSize: height / 40,
            ),
          ),
        ),
        backgroundColor: notifire.getprimerycolor,
        body: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage(
                  "images/background.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: width / 20, right: width / 20, top: height / 40),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PasswordChange.routeName);
                    },
                    child:
                        menuType("images/arrow-down.png", "Ganti Password"),
                  ),
                  SizedBox(height: height / 80),
                  Divider(
                    thickness: 0.6,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  SizedBox(height: height / 80),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PasswordForgot.routeName);
                    },
                    child: menuType("images/arrow-down.png", "Lupa Password"),
                  ),
                  SizedBox(height: height / 80),
                  Divider(
                    thickness: 0.6,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ],
              ),
            )));
  }

  Widget menuType(image, title) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 50,
              fontFamily: 'Gilroy',
            ),
          ),
          const Spacer(),
          Transform.rotate(
            angle: -90 * 3.14159 / 180,
            child: Image.asset(
              image,
              height: height / 34,
              color: notifire.getdarkscolor,
            ),
          )
        ],
      ),
    );
  }
}
