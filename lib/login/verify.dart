import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kumpulpay/onbonding.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';

class Verify extends StatefulWidget {
  static String routeName = '/login_verify_pin';
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  late ColorNotifire notifire;

  @override
  void initState() {
    super.initState();

    notifire = Provider.of<ColorNotifire>(context, listen: false);

    getdarkmodepreviousstate();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    notifire.setIsDark =
        previusstate ?? false; // Gunakan nilai default false jika null
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height / 20,
              ),
              Center(
                child: Image.asset(
                  "images/verifiy.png",
                  height: height / 5,
                ),
              ),
              SizedBox(
                height: height / 40,
              ),
              Text(
                CustomStrings.verification,
                style: TextStyle(
                    color: notifire.getdarkscolor,
                    fontSize: height / 40,
                    fontFamily: 'Gilroy Bold'),
              ),
              SizedBox(
                height: height / 40,
              ),
              Text(
                "Masukkan PIN Login Kamu",
                style: TextStyle(
                    color: notifire.getdarkgreycolor,
                    fontSize: height / 65,
                    fontFamily: 'Gilroy Medium'),
              ),
              SizedBox(
                height: height / 20,
              ),
              animatedBorders(),
              SizedBox(
                height: height / 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lupa PIN?',
                    style: TextStyle(
                      color: notifire.getdarkgreycolor.withOpacity(0.6),
                      fontSize: height / 60,
                    ),
                  ),
                  SizedBox(
                    width: width / 100,
                  ),
                  Text(
                    'Reset',
                    style: TextStyle(
                      color: notifire.getbluecolor,
                      fontSize: height / 60,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Onbonding.routeName, (route) => false);
                },
                child: Custombutton.button(
                    notifire.getbluecolor, CustomStrings.verityme, width / 2),
              ),
            ],
          ),
      )
      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: Get.height * 0.1,
      //       ),
      //       Stack(
      //         children: [
      //           Container(
      //             height: height * 0.9,
      //             width: width,
      //             color: Colors.transparent,
      //             child: Image.asset(
      //               "images/background.png",
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           Column(
      //             children: [
      //               SizedBox(
      //                 height: height / 20,
      //               ),
      //               Center(
      //                 child: Image.asset(
      //                   "images/verifiy.png",
      //                   height: height / 5,
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: height / 40,
      //               ),
      //               Text(
      //                 CustomStrings.verification,
      //                 style: TextStyle(
      //                     color: notifire.getdarkscolor,
      //                     fontSize: height / 40,
      //                     fontFamily: 'Gilroy Bold'),
      //               ),
      //               SizedBox(
      //                 height: height / 40,
      //               ),
      //               Text(
      //                 "Masukkan PIN Login Kamu",
      //                 style: TextStyle(
      //                     color: notifire.getdarkgreycolor,
      //                     fontSize: height / 65,
      //                     fontFamily: 'Gilroy Medium'),
      //               ),
                   
      //               SizedBox(
      //                 height: height / 20,
      //               ),
      //               animatedBorders(),
      //               SizedBox(
      //                 height: height / 30,
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Text(
      //                     'Lupa PIN?',
      //                     style: TextStyle(
      //                       color: notifire.getdarkgreycolor.withOpacity(0.6),
      //                       fontSize: height / 60,
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: width / 100,
      //                   ),
      //                   Text(
      //                     'Reset',
      //                     style: TextStyle(
      //                       color: notifire.getbluecolor,
      //                       fontSize: height / 60,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(
      //                 height: height / 30,
      //               ),
      //               GestureDetector(
      //                 onTap: () {
      //                   Navigator.pushNamedAndRemoveUntil(context, Onbonding.routeName, (route) => false);
      //                 },
      //                 child: Custombutton.button(notifire.getbluecolor,
      //                     CustomStrings.verityme, width / 2),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget animatedBorders() {
    return Container(
      color: notifire.getprimerycolor,
      height: height / 14,
      width: width / 1.2,
      child: OTPTextField(
          // controller: otpController,
          length: 4,
          width: MediaQuery.of(context).size.width,
          textFieldAlignment: MainAxisAlignment.spaceAround,
          otpFieldStyle: OtpFieldStyle(
            enabledBorderColor: Colors.grey.withOpacity(0.4),
            borderColor: Colors.grey.withOpacity(0.4),
          ),
          fieldWidth: 50,
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: 15,
          style: TextStyle(fontSize: 17, color: notifire.getdarkscolor),
          onChanged: (pin) {},
          onCompleted: (pin) {}),
    );
  }
}
