import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/login/login.dart';
import 'package:kumpulpay/login/verify.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/button.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';
import '../utils/string.dart';
import '../utils/textfeilds.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();

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
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          CustomStrings.register,
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontFamily: 'Gilroy Bold',
              fontSize: height / 35),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [

                // start background
                Container(
                  height: height * 0.9,
                  width: width,
                  color: Colors.transparent,
                  child: Image.asset(
                    "images/background.png",
                    fit: BoxFit.cover,
                  ),
                ),
                // end background
                
                Column(
                  children: [
                    SizedBox(
                      height: height / 13,
                    ),
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            // height: height / 1.4,
                            width: width / 1.1,
                            decoration: BoxDecoration(
                              color: notifire.gettabwhitecolor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: FormBuilder(
                              key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              child: Column(
                                  children: [
                                    SizedBox(
                                      height: height / 15,
                                    ),

                                    textfeildC("first_name", "Nama Depan", "Input nama depan",
                                        "images/fullname.png"),
                                    textfeildC(
                                        "last_name",
                                        "Nama Belakang",
                                        "Input nama belakang",
                                        "images/fullname.png"),
                                    textfeildC(
                                        "phone",
                                        "Nomor Telepon",
                                        "Input nomor telepon",
                                        "images/fullname.png", keyboardType: TextInputType.number),
                                    textfeildC("email", CustomStrings.email,
                                        "Input email", "images/email.png", validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                          FormBuilderValidators.email(),
                                        ])),
                                    textfeildC("password", CustomStrings.password,
                                        "Input password", "images/password.png",
                                        suffixIcon: "images/show.png"),
                                    textfeildC(
                                        "password_confirm", 
                                        CustomStrings.confirmpassword,
                                        "Input ulang password",
                                        "images/password.png",
                                        suffixIcon: "images/show.png"),

                                    SizedBox(
                                      height: height / 35,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // print('print: ${_formKey.currentState?.value}');
                                         if (_formKey.currentState!.saveAndValidate()) {
                                              final formData = _formKey.currentState?.value;
                                              print(formData);
                                              _submitForm(formData);
                                              // _handleSubmit(context, formData);
                                            }
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => const Verify(),
                                        //   ),
                                        // );
                                      },
                                      child: Custombutton.button(
                                          notifire.getbluecolor,
                                          CustomStrings.registeraccount,
                                          width / 2),
                                    ),

                                    // start action
                                    SizedBox(
                                      height: height / 35,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Sudah punya akun?",
                                          style: TextStyle(
                                            color: notifire.getdarkgreycolor
                                                .withOpacity(0.6),
                                            fontSize: height / 50,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width / 100,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Login disini",
                                            style: TextStyle(
                                              color: notifire.getdarkscolor,
                                              fontSize: height / 50,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                    // end action
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(
                      height: height / 40,
                    ),
                    
                  ],
                ),
                
                // start icon app
                Column(
                  children: [
                    SizedBox(
                      height: height / 60,
                    ),
                    Center(
                      child: Image.asset(
                        "images/logo_app/ic_launcher_round.webp",
                        height: height / 8,
                      ),
                    ),
                  ],
                ),
                // end icon app
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textfeildC(name, txtLabel, txtHint, icon, {keyboardType,suffixIcon, validator}) {
      return Column(
        children: [
          SizedBox(
            height: height / 35,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 18),
            child: FormBuilderTextFieldCustom.type1(
              notifire.getdarkscolor,
              notifire.getdarkgreycolor,
              notifire.getbluecolor,
              notifire.getdarkwhitecolor,
              hintText: txtHint,
              prefixIcon: icon,
              name: name,
              keyboardType: keyboardType,
              labelText: txtLabel, suffixIcon: suffixIcon, validator: validator ?? FormBuilderValidators.required()),
          )
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
      final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
      final dynamic post = await client.postRegister(jsonString);
   
      if (post["status"]) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(post["message"])));
      }
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
      // rethrow;
    }
  }
}
