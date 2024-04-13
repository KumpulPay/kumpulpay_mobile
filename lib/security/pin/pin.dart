

import 'package:flutter/material.dart';
import 'package:kumpulpay/security/pin/pin_create.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pin extends StatefulWidget {
  const Pin({Key? key}) : super(key: key);

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
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
          "Pin Transaksi",
          style: TextStyle(
            color: notifire.getdarkscolor,
            fontFamily: 'Gilroy Bold',
            fontSize: height / 40,
          ),
        ),
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
                  height: height / 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PinCreate(),
                      ),
                    );
                  },
                  child: menuType(
                      "images/arrow-down.png", "Buat / Ganti PIN"),
                ),
                SizedBox(height: height / 80),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Divider(
                    thickness: 0.6,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
                SizedBox(height: height / 80),

                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ChangePassword(),
                    //   ),
                    // );
                  },
                  child: menuType(
                      "images/arrow-down.png", "Reset PIN"),
                ),
                SizedBox(height: height / 80),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Divider(
                    thickness: 0.6,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
              ],
            )

           

          ],
        ),
      ),
    );
  }

  Widget menuType(image, title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 20),
      child: Container(
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
            Transform.rotate(angle: -90 * 3.14159 / 180,
              child: Image.asset(
                image,
                height: height / 34,
                color: notifire.getdarkscolor,
              ),
            )
            
          ],
        ),
      ),
    );
  }
}