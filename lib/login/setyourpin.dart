import 'package:flutter/material.dart';
import 'package:kumpulpay/bottombar/bottombar.dart';
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
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _onWillPop(),
      child: Scaffold(
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
                  // // SizedBox(height: height / 1.8),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height / 40),
                    child: GestureDetector(
                      onTap: () {
                        // Validasi PIN sebelum melanjutkan
                        if (_txtPin == null || _txtPin!.length < 4) {
                          setState(() {
                            _errorMessage =
                                "Kode PIN harus terdiri dari 4 angka.";
                          });
                        } else {
                          setState(() {
                            _errorMessage =
                                null; // Reset pesan error jika valid
                          });
                          // Lanjutkan ke halaman berikutnya
                          Navigator.pushNamed(context, ConfirmPin.routeName,
                              arguments: ConfirmPin(txtPin: _txtPin!));
                        }
                      },
                      child: Custombutton.button(notifire.getPrimaryPurpleColor,
                          CustomStrings.savepin, width / 1.1),
                    ),
                  )
                ],
              ))),
    );
  }

  Widget animatedBorders() {
    return Container(
      color: Colors.transparent,
      // height: height / 14,
      width: width / 1.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OTPTextField(
            length: 4,
            width: MediaQuery.of(context).size.width,
            textFieldAlignment: MainAxisAlignment.spaceAround,
            otpFieldStyle: OtpFieldStyle(
              borderColor: Colors.grey.withOpacity(0.2),
              enabledBorderColor: Colors.grey.withOpacity(0.4),
            ),
            fieldWidth: 50,
            fieldStyle: FieldStyle.box,
            outlineBorderRadius: 15,
            style: const TextStyle(fontSize: 17, color: Colors.black),
            onChanged: (pin) {
              setState(() {
                _txtPin = pin;
                _errorMessage =
                    null; // Reset pesan error saat pengguna mengetik
              });
            },
            onCompleted: (pin) {
              if (pin.length < 4) {
                setState(() {
                  _errorMessage = "Kode OTP harus terdiri dari 4 angka.";
                });
              } else {
                setState(() {
                  _errorMessage = null; // Input valid
                });
              }
            },
          ),
          if (_errorMessage != null)
            Padding(
              padding:  EdgeInsets.only(top: height/40),
              child: Text(
                _errorMessage??'PIN Wajib diisi!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

   Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width / 30),
                decoration: BoxDecoration(
                  color: notifire.getprimerycolor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                // height: height / 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: height / 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Spacer(),
                          Icon(
                            Icons.clear,
                            color: notifire.getdarkscolor,
                          ),
                          SizedBox(
                            width: width / 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Text(
                      'Apa kamu yakin?',
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontFamily: 'Gilroy Bold',
                        fontSize: height / 40,
                      ),
                    ),
                    Text(
                      'Kamu tidak mau setting PIN terlebih dulu!',
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontFamily: 'Gilroy Medium',
                        fontSize: height / 40,
                      ),
                    ),
                    SizedBox(
                      height: height / 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: height / 18,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          color: notifire.getPrimaryPurpleColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Setting PIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 55),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 100,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, Bottombar.routeName);
                      },
                      child: Container(
                        height: height / 18,
                        width: width / 2.5,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Tidak',
                            style: TextStyle(
                                color: const Color(0xffEB5757),
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 55),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                  ],
                ),
              ),
            );
          },
        )) ??
        false;
  }
}
