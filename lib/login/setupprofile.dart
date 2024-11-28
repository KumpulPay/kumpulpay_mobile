import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/login/setyourpin.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/button.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';
import '../utils/normaltextfild.dart';
import '../utils/string.dart';

class SetupProfile extends StatefulWidget {
  static String routeName = '/profile_setup';
  
  const SetupProfile({Key? key}) : super(key: key);

  @override
  State<SetupProfile> createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  late ColorNotifire notifire;
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _ctrName = TextEditingController();
  final TextEditingController dateController= TextEditingController();
  dynamic googleProfile;

  @override
  void initState() {
    super.initState();
    googleProfile = jsonDecode(SharedPrefs().googleProfile); 
    _ctrName.text = googleProfile['name'];
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

  String dropdownvalue = '01';
  String monthvalue = 'Jan';
  String yearvalue = '2018';
  String gendervalue = '';

  var items = [
    '01',
    '02',
    '03',
    '04',
    '05',
  ];
  var monthitems = [
    'Jan',
    'feb',
    'mar',
    'ape',
    'may',
  ];
  var yearitems = [
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
  ];
  var genderitems = [
    CustomStrings.male,
    CustomStrings.female,
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            CustomStrings.setupprofile,
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontSize: height / 40,
                fontFamily: 'Gilroy Bold'),
          ),
          backgroundColor: notifire.getprimerycolor,
          elevation: 0,
          // actions: [
          //   Center(
          //     child: Text(
          //       CustomStrings.skip,
          //       style: TextStyle(
          //           color: notifire.getdarkscolor, fontFamily: 'Gilroy Bold'),
          //     ),
          //   ),
          //   const SizedBox(
          //     width: 10,
          //   )
          // ],
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
              Expanded(
                child: SingleChildScrollView(
                  // physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: height / 12,
                              ),
                              Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      // height: height / 1.25,
                                      width: width / 1.1,
                                      decoration: BoxDecoration(
                                        color: notifire.gettabwhitecolor,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(40),
                                          topLeft: Radius.circular(40),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: height / 8.5),
                                          // Row(
                                          //   children: [
                                          //     SizedBox(
                                          //       width: width / 18,
                                          //     ),
                                          //     Text(
                                          //       CustomStrings.personalinformations,
                                          //       style: TextStyle(
                                          //           color: notifire.getdarkscolor,
                                          //           fontSize: height / 45,
                                          //           fontFamily: 'Gilroy Bold'),
                                          //     ),
                                          //   ],
                                          // ),
                                          SizedBox(height: height / 40),
                                          Container(
                                              // height: height / 2,
                                              width: width / 1.25,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                              child: IntrinsicHeight(
                                                child: Column(
                                                  children: [
                                                    FormBuilder(
                                                        key: _formKey,
                                                        autovalidateMode:
                                                            AutovalidateMode.onUserInteraction,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                                height: height /
                                                                    70),
                                                            inputName(_ctrName),
                                                            SizedBox(
                                                                height: height /
                                                                    60),
                                                            inputPhone(),
                                                            SizedBox(
                                                                height: height /
                                                                    60),
                                                            inputDateOfBirth(),
                                                            SizedBox(
                                                                height: height /
                                                                    60),
                                                            inputGender(),
                                                            SizedBox(
                                                                height: height /
                                                                    50),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              )),
                                          SizedBox(height: height / 32),
                                          GestureDetector(
                                            onTap: () {
                                              if (_formKey.currentState!
                                                  .saveAndValidate()) {
                                                    dynamic formData = _formKey
                                                    .currentState?.value;
                                                print('formDataX ${formData}');
                                                _submitForm(formData);
                                              }                                              
                                            },
                                            child: Custombutton.button(
                                                notifire.getPrimaryPurpleColor,
                                                CustomStrings.continues,
                                                width / 2),
                                          ),
                                          SizedBox(height: height / 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: height / 50,
                              ),
                              Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: height / 6,
                                      width: width / 2.5,
                                      decoration: BoxDecoration(
                                        color: notifire.getPrimaryPurpleColor
                                            .withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Helpers.setCachedNetworkImage(
                                              googleProfile['avatar'] ?? Icon(
                                            Icons.person,
                                            size: height / 9,
                                            color: notifire.getPrimaryPurpleColor,
                                          ),
                                              height_: height / 9)
                                          
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 3.5, top: height / 10),
                                      child: Image.asset("images/adprofile.png",
                                          height: height / 22),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

   Widget inputName(ctrName) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: width / 20),
            Text(
              CustomStrings.fullnamee,
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontSize: height / 50,
                  fontFamily: 'Gilroy Bold'),
            )
          ],
        ),
        SizedBox(height: height / 80),
        NormalCustomtextfilds.textField(
            name: 'name',
            textclr: notifire.getdarkscolor,
            hintclr: notifire.getdarkgreycolor,
            borderclr: notifire.getPrimaryPurpleColor,
            hinttext: 'Masukan nama lengkap',
            w: width / 20,
            fillcolor: notifire.gettabwhitecolor,
            context: context, 
            controller: ctrName, 
            validator: FormBuilderValidators.required()
        ),
      ],
    );
  }

  Widget inputPhone(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: width / 20),
            Text(
              CustomStrings.contactnumber,
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontSize: height / 50,
                  fontFamily: 'Gilroy Bold'),
            )
          ],
        ),
        SizedBox(height: height / 80),
        NormalCustomtextfilds.textField(
            name: 'phone',
            textclr: notifire.getdarkscolor,
            hintclr: notifire.getdarkgreycolor,
            borderclr: notifire.getPrimaryPurpleColor,
            hinttext: "Masukan nomor telepon",
            w: width / 20,
            fillcolor: notifire.gettabwhitecolor,
            context: context,
            keyboardType: TextInputType.phone,
            validator: FormBuilderValidators.required()),
      ],
    );
  }

  Widget inputDateOfBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Text(
            CustomStrings.dateofbirth,
            style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 50,
              fontFamily: 'Gilroy Bold',
            ),
          ),
        ),
        SizedBox(height: height / 80),
        NormalCustomtextfilds.textField(
          name: 'date_of_birth',
          textclr: notifire.getdarkscolor,
          hintclr: notifire.getdarkgreycolor,
          borderclr: notifire.getPrimaryPurpleColor,
          hinttext: 'Masukkan tanggal lahir',
          w: width / 20,
          fillcolor: notifire.gettabwhitecolor,
          context: context,
          controller: dateController, // Menggunakan controller
          validator: FormBuilderValidators.required(
            errorText: 'Tanggal lahir wajib diisi',
          ),
          readOnly: true,
          suffixIcon: const Icon(Icons.date_range),
          onTap: () async {
            // Menampilkan date picker
            final DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(3000),
            );
            if (dateTime != null) {
              // Format tanggal
              final String formattedDate =
                  "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

              // Memperbarui nilai di controller
              dateController.text = formattedDate;

              // Mengupdate nilai di FormBuilder
              FormBuilder.of(context)
                  ?.fields['date_of_birth']
                  ?.didChange(formattedDate);
            }
          },
        ),
      ],
    );
  }

  Widget inputGender() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CustomStrings.gender,
            style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 50,
              fontFamily: 'Gilroy Bold',
            ),
          ),
          SizedBox(height: height / 80),
          FormBuilderDropdown<String>(
            name: 'gender',
            initialValue: gendervalue,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              filled: true,
              fillColor: notifire.getwhite,
              hintText: 'Pilih jenis kelamin',
              hintStyle: TextStyle(color: notifire.getdarkgreycolor, fontSize: height / 60),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(10)),
            ),
            dropdownColor: notifire.getprimerydarkcolor,
            style: TextStyle(
              fontSize: height / 50,
              color: notifire.getdarkscolor,
            ),
            isExpanded: true,
            icon: Image.asset(
              'images/arrow-down.png',
              scale: 5,
              color: notifire.getdarkscolor,
            ),
            items: genderitems.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: height / 60),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                gendervalue = newValue!;
              });
            },
            validator: FormBuilderValidators.required(
              errorText: 'Pilih jenis kelamin',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm(formData) async {
   
    dynamic userData = {
      "avatar": googleProfile['avatar'],
      "name": formData['name'],
      "email": googleProfile['email'],
      "phone": formData['phone'],
      "date_of_birth": formData['date_of_birth'],
      "gender": formData['gender'],
    };
   
    await Future.delayed(const Duration(seconds: 1));

    final response = await ApiClient(AppConfig().configDio()).patchProfile(
      authorization: 'Bearer ${SharedPrefs().token}',
      body: userData,
    );
    try {
      if (response.success) {
        SharedPrefs().userData = jsonEncode(response.data['user']);
        
        Navigator.pushNamed(context, Setyourpin.routeName);
      } else {
        // Gagal, misalnya kesalahan dari server
        throw Exception('Gagal memperbarui data.');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      rethrow;
    }
  }


}
