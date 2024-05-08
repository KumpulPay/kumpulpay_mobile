import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';
import '../utils/string.dart';

class EditProfile extends StatefulWidget {
  static String routeName = '/profile_edit';
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    userData = json.decode(SharedPrefs().userData);
    _ctrFullName.text = userData["name"];
    _ctrPhone.text = userData["phone"];
    _ctrEmail.text = userData["email"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        elevation: 0,
        title: Text(
          CustomStrings.myprofile,
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
        centerTitle: true,
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: height * 0.8,
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
                  height: height / 60,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: height / 8,
                        width: width / 4,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset("images/profile.png"),
                      ),
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: height / 13,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width / 1.8,
                                ),
                                Image.asset(
                                  "images/camera.png",
                                  height: height / 28,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
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
                    fillClr: notifire.getdarkwhitecolor,
                    enabled: false),

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
                    enabled: false),
                    
                SizedBox(
                  height: height / 50,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 20,
                    ),
                    Text(
                      CustomStrings.address,
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
                    height: height / 9,
                    child: TextField(
                      maxLines: 4,
                      autofocus: false,
                      style: TextStyle(
                        fontSize: height / 50,
                        color: notifire.getdarkscolor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(height / 100),
                        filled: true,
                        fillColor: notifire.getdarkwhitecolor,
                        hintText: CustomStrings.address,
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
                SizedBox(
                  height: height / 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Dalam pengembangan")));
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const Bottombar(),
                      //   ),
                      // );
                    },
                    child: Container(
                      height: height / 15,
                      width: width,
                      decoration: BoxDecoration(
                        color: notifire.getbluecolor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          CustomStrings.savechange,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height / 50,
                              fontFamily: 'Gilroy Bold'),
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
