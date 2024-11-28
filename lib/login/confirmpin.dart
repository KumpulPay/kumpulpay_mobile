import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:kumpulpay/verification/verificationdone.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../utils/button.dart';

class ConfirmPin extends StatefulWidget {
  static String routeName = '/pin_confirm'; 
  final String? txtPin;
  const ConfirmPin({Key? key, this.txtPin}) : super(key: key);

  @override
  State<ConfirmPin> createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
  late ColorNotifire notifire;
  ConfirmPin? args;
  String? _txtPin, _txtPinConfirm;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as ConfirmPin;
      _txtPin = args!.txtPin;
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: notifire.getdarkscolor),
          elevation: 0,
          backgroundColor: notifire.getprimerycolor,
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
                    CustomStrings.confirmyourpin,
                    style: TextStyle(
                      fontFamily: 'Gilroy Bold',
                      color: notifire.getdarkscolor,
                      fontSize: height / 30,
                    ),
                  ),
                  SizedBox(width: width / 80),
                ],
              ),
              SizedBox(height: height / 80),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Pastikan PIN yang Anda masukkan sudah benar',
                  style: TextStyle(
                    color: notifire.getdarkgreycolor,
                    fontFamily: 'Gilroy Medium',
                    fontSize: height / 60,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                )
              ),
              SizedBox(height: height / 30),
              animatedBorders(),
              const Spacer(),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: height / 40),
              //   child: GestureDetector(
              //     onTap: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(
              //       //     builder: (context) => const VerificationDone(),
              //       //   ),
              //       // );
              //     },
              //     child: Custombutton.button(notifire.getPrimaryPurpleColor,
              //         'Konfimasi PIN', width / 1.1),
              //   ),
              // )
              Padding(
                padding: EdgeInsets.symmetric(vertical: height / 40),
                child: GestureDetector(
                  onTap: isLoading ? null : _submitForm,
                  child: Container(
                    height: height / 15,
                    width: width / 1.1,
                    // padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: notifire.getPrimaryPurpleColor, // Ganti dengan warna yang diinginkan
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Konfirmasi PIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isLoading) ...[
                          const SizedBox(width: 10), // Spasi antara teks dan loader
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
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
            enabledBorderColor: Colors.grey.withOpacity(0.4),
            borderColor: Colors.grey.withOpacity(0.4),
          ),
          fieldWidth: 50,
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: 15,
          style: TextStyle(fontSize: 17, color: notifire.getdarkscolor),
          onChanged: (pin) {
            _txtPinConfirm = pin;
          },
          onCompleted: (pin) {}),
    );
  }

  void _submitForm() async {
    if (_txtPin != _txtPinConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN konfirmasi tidak sesuai!')),
      );
      return; // Berhenti jika PIN tidak sesuai
    }

    setState(() {
      isLoading = true; // Mulai loading
    });

    // Menyiapkan data untuk API
    dynamic body = {
      "pin_transaction_new": _txtPin,
      "pin_transaction_confirm_new": _txtPinConfirm,
    };
    print('bodyX $body');
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    try {
      final response = await client.postPinCreate(
        authorization: 'Bearer ${SharedPrefs().token}',
        body: jsonEncode(body),
      );

      // Jika response berhasil
      if (response.status) {
        setState(() {
          isLoading = false; // Selesai loading
        });
        Navigator.pushNamed(context, VerificationDone.routeName);
      } else {
        throw Exception('Gagal memperbarui data.');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Selesai loading
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

}
