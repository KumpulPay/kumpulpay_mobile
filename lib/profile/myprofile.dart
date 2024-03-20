import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/profile/editprofile.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colornotifire.dart';
import '../utils/string.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late ColorNotifire notifire;
  Map<String, dynamic> userData = {};
  final TextEditingController _ctrFullName = TextEditingController();
  final TextEditingController _ctrPhone = TextEditingController();
  final TextEditingController _ctrEmail = TextEditingController();

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
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
  }

  @override
  Widget build(BuildContext context) {
    userData = json.decode(SharedPrefs().userData);
    _ctrFullName.text = userData["name"];
    _ctrPhone.text = userData["phone"];
    _ctrEmail.text = userData["email"];

    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        title: Text(
          CustomStrings.myprofile,
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfile(),
                ),
              );
            },
            child: Image.asset(
              "images/editprofile.png",
              scale: 3.5,
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
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
            Column(
              children: [
                SizedBox(
                  height: height / 40,
                ),
                Container(
                  height: height / 8,
                  width: width / 4,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("images/profile.png"),
                ),

                SizedBox(
                  height: height / 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 20,
                    ),
                    Text(
                      "Nama Lengkap",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: height / 50,
                          fontFamily: 'Gilroy Medium'),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 50,
                ),
                Dinamistextfilds.textField(
                    controller: _ctrFullName,
                    txtClr: notifire.getdarkscolor,
                    histClr: notifire.getdarkgreycolor,
                    hintTxt: "Nama Lengkap",
                    borderClr: notifire.getbluecolor,
                    fillClr: notifire.getdarkwhitecolor),
              
                SizedBox(
                  height: height / 50,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 20,
                    ),
                    Text(
                      CustomStrings.email,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: height / 50,
                          fontFamily: 'Gilroy Medium'),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 50,
                ),
                Dinamistextfilds.textField(
                    controller: _ctrEmail,
                    txtClr: notifire.getdarkscolor,
                    histClr: notifire.getdarkgreycolor,
                    hintTxt: CustomStrings.email,
                    borderClr: notifire.getbluecolor,
                    fillClr: notifire.getdarkwhitecolor, enabled: false),
      
                SizedBox(
                  height: height / 50,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 20,
                    ),
                    Text(
                      "Telepon",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: height / 50,
                          fontFamily: 'Gilroy Medium'),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 50,
                ),
                Dinamistextfilds.textField(
                  controller: _ctrPhone,
                  txtClr: notifire.getdarkscolor,
                  histClr: notifire.getdarkgreycolor,
                  hintTxt: "Telepon",
                  borderClr: notifire.getbluecolor,
                  fillClr: notifire.getdarkwhitecolor,
                  enabled: false
                ),
                SizedBox(
                  height: height / 50,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 20,
                    ),
                    Text(
                      "Alamat",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: height / 50,
                          fontFamily: 'Gilroy Medium'),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 50,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 18),
                  child: Container(
                    color: Colors.transparent,
                    height: height / 4,
                    child: TextField(
                      maxLines: 3,
                      autofocus: false,
                      style: TextStyle(
                        fontSize: height / 50,
                        color: notifire.getdarkscolor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(height / 100),
                        filled: true,
                        fillColor: notifire.getprimerydarkcolor,
                        hintText: "Alamat",
                        hintStyle: TextStyle(
                            color: notifire.getdarkgreycolor,
                            fontSize: height / 60),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: notifire.getbluecolor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffd3d3d3),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
