import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kumpulpay/bottombar/bottombar.dart';
import 'package:kumpulpay/category/category.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/transaction/history_all.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import '../../utils/button.dart';

class ConfirmPin extends StatefulWidget {
  static String routeName = '/confirm_pin';
  final dynamic formData;
  const ConfirmPin({Key? key, this.formData}) : super(key: key);

  @override
  State<ConfirmPin> createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
  ConfirmPin? _args;
  dynamic _formData;
  final _globalKey = GlobalKey<State>();
  late ColorNotifire notifire;
  final OtpFieldController _ctrPinTransaction = OtpFieldController();
  String _txtPinTransaction = "";

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as ConfirmPin?;
    _formData = _args!.formData;
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        // centerTitle: true,
        title: Text(
          "Konfirmasi Pembayaran",
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
            "Masukkan Pin",
            style: TextStyle(
              fontFamily: 'Gilroy Bold',
              color: notifire.getdarkscolor,
              fontSize: height / 30,
            ),
          ),
          SizedBox(height: height / 80),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 30),
            child: Text(
              "Silakan masukkan PIN kamu untuk mengkonfirmasi pembayaran",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: notifire.getdarkgreycolor,
                fontFamily: 'Gilroy Medium',
                fontSize: height / 60,
              ),
            ),
          ),
          SizedBox(height: height / 30),
          animatedBorders(),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _submitForm(_txtPinTransaction);
            },
            child: Custombutton.button(
                notifire.getPrimaryPurpleColor, "Konfirmasi", width / 1.1),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
            canPop: false,
            onPopInvoked: (didPop) => Navigator.pushNamedAndRemoveUntil(context,
                HistoryAll.routeName, ModalRoute.withName(Category.routeName)),
            child: Dialog(
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
                      "Transaksi Berhasil!",
                      style: TextStyle(
                        color: notifire.getPrimaryPurpleColor,
                        fontFamily: 'Gilroy Bold',
                        fontSize: height / 40,
                      ),
                    ),
                    SizedBox(
                      height: height / 100,
                    ),
                    Text(
                      "Transaksi dikirim mohon tunggu!",
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
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            HistoryAll.routeName,
                            ModalRoute.withName(Category.routeName));
                      },
                      child: buttons(notifire.getPrimaryPurpleColor, "Lihat Transaksi",
                          Colors.white),
                    ),
                    SizedBox(
                      height: height / 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Bottombar.routeName, (route) => false);
                      },
                      child: buttons(const Color(0xffd3d3d3),
                          CustomStrings.home, notifire.getPrimaryPurpleColor),
                    ),
                  ],
                ),
              ),
            ));
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
          controller: _ctrPinTransaction,
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
            _txtPinTransaction = pin;
          },
          onCompleted: (value) {
            _submitForm(value);
          },
        ));
  }

  Future<void> _submitForm(String txtPinTransaction) async {
    Loading.showLoadingLogoDialog(context, _globalKey);
    try {
      if (txtPinTransaction.isEmpty || txtPinTransaction.length < 4) {
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Pin tidak valid!")));
        return;
      }

      Map<String, dynamic> body = {"pin_transaction": txtPinTransaction};
      body.addAll(_formData);

      final response = await ApiClient(AppConfig().configDio(context: context))
          .postPpobTransaction(
              authorization: 'Bearer ${SharedPrefs().token}', body: body);

      Navigator.pop(context);
      
      if (response.success) {
        _showMyDialog();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      Navigator.pop(context);
    }
  }

}
