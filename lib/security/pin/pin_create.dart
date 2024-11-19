import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCreate extends StatefulWidget {
  static String routeName = '/security/pin/create';
  const PinCreate({Key? key}) : super(key: key);

  @override
  State<PinCreate> createState() => _PinCreateState();
}

class _PinCreateState extends State<PinCreate> {
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _obscureText2 = true;
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

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
            "Buat / Ganti PIN",
            style: TextStyle(
              color: notifire.getdarkscolor,
              fontFamily: 'Gilroy Bold',
              fontSize: height / 40,
            ),
          ),
        ),
        backgroundColor: notifire.getprimerycolor,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Masukkan pin baru kamu untuk melakukan transaksi",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Gilroy Bold',
                          fontSize: height / 60,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height / 50,
                    ),
                    textfeildC("pin_transaction_current", "PIN Lama",
                        hintText: "Masukkan PIN lama",
                        prefixIcon: "images/password.png",
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(4),
                        ]),
                        suffixIconInteractive: GestureDetector(
                            onTap: () {
                              _toggle();
                            },
                            child: _obscureText
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height / 50,
                                        horizontal: height / 70),
                                    child: Image.asset(
                                      "images/eye.png",
                                      height: height / 50,
                                    ),
                                  )
                                : const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey,
                                  ))),
                    textfeildC("pin_transaction_new", "PIN Baru",
                        hintText: "Masukkan PIN baru",
                        prefixIcon: "images/password.png",
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(4)
                        ]),
                        suffixIconInteractive: GestureDetector(
                            onTap: () {
                              _toggle2();
                            },
                            child: _obscureText
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height / 50,
                                        horizontal: height / 70),
                                    child: Image.asset(
                                      "images/eye.png",
                                      height: height / 50,
                                    ),
                                  )
                                : const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey,
                                  ))),
                    textfeildC(
                        "pin_transaction_confirm_new", "Konfirmasi PIN baru",
                        hintText: "Masukkan konfirmasi PIN baru",
                        prefixIcon: "images/password.png",
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(4)
                        ]),
                        suffixIconInteractive: GestureDetector(
                            onTap: () {
                              _toggle();
                            },
                            child: _obscureText
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height / 50,
                                        horizontal: height / 70),
                                    child: Image.asset(
                                      "images/eye.png",
                                      height: height / 50,
                                    ),
                                  )
                                : const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey,
                                  ))),

                    SizedBox(
                      height: height / 50,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width / 20,
                        ),
                        Image.asset(
                          "images/match.png",
                          height: height / 40,
                        ),
                        SizedBox(
                          width: width / 100,
                        ),
                        Text(
                          CustomStrings.passwordmatch,
                          style: TextStyle(
                            color: const Color(0xff00BF71),
                            fontFamily: 'Gilroy Medium',
                            fontSize: height / 60,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Positioned(
                  bottom: height / 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          final formData = _formKey.currentState?.value;
                          // print('print: ${formData}');
                          _submitForm(formData);
                        }
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
                            "Simpan PIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy Medium',
                                fontSize: height / 50),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget textfeildC(name, labelText_,
      {hintText,
      labelText,
      prefixIcon,
      suffixIconInteractive,
      keyboardType,
      suffixIcon,
      validator,
      maxLength}) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            SizedBox(
              width: width / 20,
            ),
            Text(
              labelText_,
              style: TextStyle(
                color: notifire.getdarkscolor,
                fontFamily: 'Gilroy Bold',
                fontSize: height / 50,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height / 50,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 20),
            child: FormBuilderTextFieldCustom.type1(
                notifire.getdarkscolor,
                Colors.grey, //hint color
                notifire.getPrimaryPurpleColor,
                notifire.getdarkwhitecolor,
                hintText: hintText,
                prefixIcon: prefixIcon,
                name: name,
                keyboardType: keyboardType,
                labelText: labelText,
                // suffixIcon: suffixIcon,
                suffixIconInteractive: suffixIconInteractive,
                maxLength: maxLength,
                validator: validator ?? FormBuilderValidators.required()))
      ],
    );
  }

  Future<void> _submitForm(dynamic formData) async {
    try {
      Map<String, dynamic> body = {};
      body.addAll(formData);
      String jsonString = json.encode(body);
      // print("print: ${jsonString}");

      Loading.showLoadingDialog(context, _globalKey);
      final client =
          ApiClient(Dio(BaseOptions(contentType: "application/json")));
      final dynamic post = await client.postPinCreate('Bearer ${SharedPrefs().token}', jsonString);
      // print(post);
      if (post["status"]) {

          ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(post["message"])));
      } else {
          ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(post["message"])));
      }
      Navigator.pop(context);
    } on DioException catch (e) {
      Navigator.pop(context);
      // print("error: ${e}");
      if (e.response != null) {
        // print(e.response?.data);
        // print(e.response?.headers);
        // print(e.response?.requestOptions);
        bool status = e.response?.data["status"];
        if (status) {
          // return Center(child: Text('Upst...'));
          // return e.response;
        }
      } else {
        // print(e.requestOptions);
        // print(e.message);
      }
    }
  }
}
