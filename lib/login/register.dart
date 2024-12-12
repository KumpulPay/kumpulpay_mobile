import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/login/login.dart';
import 'package:kumpulpay/login/verify.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/device_info_util.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/button.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';
import '../utils/string.dart';
import '../utils/textfeilds.dart';

class Register extends StatefulWidget {
  static String routeName = '/register';
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
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [

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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40)),
                                        ),
                                        child: FormBuilder(
                                          key: _formKey,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: height / 15,
                                              ),

                                              textfeildC(
                                                  "name",
                                                  "Nama Lengkap",
                                                  "Input nama lengkap",
                                                  "images/fullname.png"),
                                              textfeildC(
                                                  "phone",
                                                  "Nomor Telepon",
                                                  "Input nomor telepon",
                                                  "images/fullname.png",
                                                  keyboardType:
                                                      TextInputType.number),
                                              textfeildC(
                                                  "email",
                                                  CustomStrings.email,
                                                  "Input email",
                                                  "images/email.png",
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators
                                                        .required(),
                                                    FormBuilderValidators
                                                        .email(),
                                                  ])),
                                              textfeildC(
                                                  "password",
                                                  CustomStrings.password,
                                                  "Input password",
                                                  "images/password.png",
                                                  suffixIcon:
                                                      "images/show.png"),
                                              textfeildC(
                                                  "password_confirm",
                                                  CustomStrings.confirmpassword,
                                                  "Input ulang password",
                                                  "images/password.png",
                                                  suffixIcon:
                                                      "images/show.png"),

                                              SizedBox(
                                                height: height / 35,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (_formKey.currentState!
                                                      .saveAndValidate()) {
                                                    final formData = _formKey
                                                        .currentState?.value;
                                                    
                                                    // Navigator.pushNamed(context,Verify.routeName);
                                                    _submitForm(formData);
                                                  }
                                                },
                                                child: Custombutton.button(
                                                    notifire
                                                        .getPrimaryPurpleColor,
                                                    'Daftar',
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
                                                      color: notifire
                                                          .getdarkgreycolor
                                                          .withOpacity(0.6),
                                                      fontSize: height / 50,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 100,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Login disini",
                                                      style: TextStyle(
                                                        color: notifire
                                                            .getdarkscolor,
                                                        fontSize: height / 50,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                              // end action
                                            ],
                                          ),
                                        )),
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
                                  "images/logo_app/playstore.png",
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
            )
          ],
        ),
      ) 
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
              notifire.getPrimaryPurpleColor,
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
   
    Loading.showLoadingLogoDialog(context, _globalKey);
    try {
      var deviceData = await DeviceInfoUtil.initPlatformState();
      dynamic deviceInfo = jsonEncode(deviceData);

      var mutableFormData = Map<String, dynamic>.from(formData);

      mutableFormData['device_info'] = deviceInfo;
     
      final response = await ApiClient(AppConfig().dio)
          .postRegister(body: mutableFormData);

      Navigator.pop(context);

      if (response.success) {
        Navigator.pushNamed(
          context, Verify.routeName
        );
       
      } else {
        
        String errorMessage = response.message;
        Map<String, dynamic> errors = response.data;

        List<String> dynamicErrors = [];

        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            dynamicErrors.add('${key}: ${value.join(', ')}');
          }
        });

        if (dynamicErrors.isNotEmpty) {
          errorMessage += '\n' + dynamicErrors.join('\n');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: notifire.getbluecolor,),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      rethrow;
    }
  }
}
