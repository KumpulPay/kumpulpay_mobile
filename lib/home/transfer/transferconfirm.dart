import 'package:flutter/material.dart';
import 'package:kumpulpay/bottombar/bottombar.dart';
import 'package:kumpulpay/card/inoutpayment.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import '../../utils/button.dart';

class TransferConfirm extends StatefulWidget {
  const TransferConfirm({Key? key}) : super(key: key);

  @override
  State<TransferConfirm> createState() => _TransferConfirmState();
}

class _TransferConfirmState extends State<TransferConfirm> {
  late ColorNotifire notifire;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        // centerTitle: true,
        title: Text(
          CustomStrings.confirmpayment,
          style: TextStyle(
            color: notifire.getdarkscolor,
            fontFamily: 'Gilroy Bold',
            fontSize: height / 40,
          ),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: Column(
        children: [
          SizedBox(height: height / 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 20),
          ),
          SizedBox(height: height / 20),
          Text(
            CustomStrings.enteryourpin,
            style: TextStyle(
              fontFamily: 'Gilroy Bold',
              color: notifire.getdarkscolor,
              fontSize: height / 30,
            ),
          ),
          SizedBox(height: height / 80),
          Text(
            CustomStrings.pleasepayment,
            style: TextStyle(
              color: notifire.getdarkgreycolor,
              fontFamily: 'Gilroy Medium',
              fontSize: height / 60,
            ),
          ),
          SizedBox(height: height / 30),
          animatedBorders(),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _showMyDialog();
            },
            child: Custombutton.button(notifire.getbluecolor,
                CustomStrings.confirmpayment, width / 1.1),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: notifire.gettabwhitecolor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            height: height / 2,
            child: Column(
              children: [
                SizedBox(
                  height: height / 40,
                ),
                Image.asset(
                  "images/paymentsuccess.png",
                  height: height / 5,
                ),
                SizedBox(
                  height: height / 40,
                ),
                Text(
                  CustomStrings.transfersuccessful,
                  style: TextStyle(
                    color: notifire.getbluecolor,
                    fontFamily: 'Gilroy Bold',
                    fontSize: height / 40,
                  ),
                ),
                SizedBox(
                  height: height / 100,
                ),
                Text(
                  CustomStrings.transfersent,
                  style: TextStyle(
                    color: notifire.getdarkgreycolor,
                    fontFamily: 'Gilroy Bold',
                    fontSize: height / 60,
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InOutPayment(),
                      ),
                    );
                  },
                  child: buttons(notifire.getbluecolor,
                      CustomStrings.viewreceipt, Colors.white),
                ),
                SizedBox(
                  height: height / 60,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Bottombar(),
                      ),
                    );
                  },
                  child: buttons(const Color(0xffd3d3d3), CustomStrings.home,
                      notifire.getbluecolor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buttons(clr, txt, clr2) {
    return Container(
      height: height / 20,
      width: width / 2,
      decoration: BoxDecoration(
        color: clr,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          txt,
          style: TextStyle(
              color: clr2, fontSize: height / 60, fontFamily: 'Gilroy Bold'),
        ),
      ),
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
