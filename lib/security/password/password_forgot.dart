import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordForgot extends StatefulWidget {
  static String routeName = '/security/password/forgot';
  const PasswordForgot({Key? key}) : super(key: key);

  @override
  State<PasswordForgot> createState() => _PasswordForgotState();
}

class _PasswordForgotState extends State<PasswordForgot> {
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
        centerTitle: true,
        title: Text(
          CustomStrings.forgotpasswords,
          style: TextStyle(
              fontSize: height / 40,
              color: notifire.getdarkscolor,
              fontFamily: 'Gilroy Bold'),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: height * 0.9,
              width: width,
              color: Colors.transparent,
              child: Image.asset(
                "images/background.png",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: height / 20,
                ),
                Image.asset(
                  "images/forgotp.png",
                  height: height / 7,
                ),
                SizedBox(
                  height: height / 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 20,
                    ),
                    Text(
                      CustomStrings.resetyourpassword,
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontSize: height / 40,
                        fontFamily: 'Gilroy Bold',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 100,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 20,
                    ),
                    Text(
                      CustomStrings.linkemail,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: height / 60,
                        fontFamily: 'Gilroy Bold',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 20,
                    ),
                    Text(
                      CustomStrings.email,
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontSize: height / 50,
                        fontFamily: 'Gilroy Bold',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 60,
                ),
                Customtextfilds.textField(
                    notifire.getdarkscolor,
                    notifire.getdarkgreycolor,
                    notifire.getPrimaryPurpleColor,
                    "images/email.png",
                    CustomStrings.emailhint,
                    notifire.getdarkwhitecolor),
                SizedBox(
                  height: height / 2.8,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: height / 17,
                      width: width,
                      decoration: BoxDecoration(
                        color: notifire.getPrimaryPurpleColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          CustomStrings.sendemail,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gilroy Medium',
                              fontSize: height / 50),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
