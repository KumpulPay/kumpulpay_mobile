import 'package:flutter/material.dart';
import 'package:kumpulpay/login/confirmpin.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../utils/button.dart';

class Setyourpin extends StatefulWidget {
  static String routeName = '/pin_create';
  const Setyourpin({Key? key}) : super(key: key);

  @override
  State<Setyourpin> createState() => _SetyourpinState();
}

class _SetyourpinState extends State<Setyourpin> {
  late ColorNotifire notifire;
  String? _txtPin;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: notifire.getprimerycolor,
          elevation: 0,
          iconTheme: IconThemeData(color: notifire.getdarkscolor),
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
            child: Column(
              children: [
                SizedBox(height: height / 20),
                Row(
                  children: [
                    SizedBox(width: width / 20),
                    Text(
                      'Buat PIN Amanmu',
                      style: TextStyle(
                          fontFamily: 'Gilroy Bold',
                          fontSize: height / 30,
                          color: notifire.getdarkscolor),
                    ),
                    SizedBox(width: width / 80),
                  ],
                ),
                SizedBox(height: height / 80),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Text(
                    'Gunakan PIN ini untuk login dan memastikan setiap transaksi tetap aman dan nyaman!',
                    style: TextStyle(
                      color: notifire.getdarkgreycolor,
                      fontFamily: 'Gilroy Medium',
                      fontSize: height / 60,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(height: height / 30),
                animatedBorders(),
                // SizedBox(height: height / 1.8),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height / 40),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ConfirmPin.routeName, arguments: ConfirmPin(txtPin: _txtPin));
                    },
                    child: Custombutton.button(notifire.getPrimaryPurpleColor,
                        CustomStrings.savepin, width / 1.1),
                  ),
                )
              ],
            )));
  }

  Widget animatedBorders() {
    return Container(
      color: Colors.transparent,
      height: height / 14,
      width: width / 1.2,
      child: OTPTextField(
          // controller: otpController,
          length: 4,
          width: MediaQuery.of(context).size.width,
          textFieldAlignment: MainAxisAlignment.spaceAround,
          otpFieldStyle: OtpFieldStyle(
              borderColor: Colors.grey.withOpacity(0.2),
              enabledBorderColor: Colors.grey.withOpacity(0.4)),
          fieldWidth: 50,
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: 15,
          style: TextStyle(fontSize: 17, color: notifire.getdarkscolor),
          onChanged: (pin) {
            _txtPin = pin;
          },
          onCompleted: (pin) {}),
    );
  }
}
