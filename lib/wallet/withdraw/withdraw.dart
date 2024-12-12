import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/colornotifire.dart';
import '../../../utils/media.dart';

class Withdraw extends StatefulWidget {
  static String routeName = '/withdraw';
  const Withdraw({Key? key}) : super(key: key);

  @override
  State<Withdraw> createState() => _TopupState();
}

class _TopupState extends State<Withdraw> {
  final _globalKey = GlobalKey<State>();
  late ColorNotifire notifire;
  int _selectedIndex = 1;
  final TextEditingController _ctrAmount = TextEditingController();

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  List img = [
    "images/citi.png",
    "images/boa.png",
    "images/usbank.png",
    "images/barclays.png",
    "images/hsbc.png",
    "images/deutsche.jpg",
    "images/dbs.png"
  ];
  List bankname = [
    "Citibank",
    "Bank of America",
    "usbank",
    "Barclays Bank",
    "HSBC India",
    "Deutsche Bank",
    "DBS Bank"
  ];

  List paymentMethod = [
    "Transfer Bank",
  ];
  List amount = [
    "50.000",
    "100.000",
    "250.000",
    "500.000",
    "750.000",
    "1.000.000",
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.4)),
            ),
            child: Icon(Icons.arrow_back, color: notifire.getdarkscolor),
          ),
        ),
        title: Text(
          "Tarik Deposit",
          style: TextStyle(
            color: notifire.getdarkscolor,
            fontFamily: 'Gilroy Bold',
            fontSize: height / 40,
          ),
        ),
        centerTitle: false,
        // actions: [
        //   Container(
        //       height: 40,
        //       width: 40,
        //       margin: const EdgeInsets.all(8),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(color: Colors.grey.withOpacity(0.4)),
        //       ),
        //       child: Image.asset(
        //         'images/info.png',
        //         color: notifire.getdarkscolor,
        //         scale: 4.5,
        //       )),
        // ],
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(
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
                      height: height / 50,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Text(
                            "Kirim ke Bank",
                            style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 43,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                    Container(
                      color: Colors.transparent,
                      // height: height / 8,
                      // width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: width / 20, right: width / 20),
                        scrollDirection: Axis.vertical,
                        itemCount: paymentMethod.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Container(
                                height: height / 15,
                                // width: width / 3,
                                width: width / 3,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: notifire.getPrimaryPurpleColor
                                          .withOpacity(0.4),
                                      blurRadius:
                                          _selectedIndex == index ? 5.0 : 0.0,
                                    ),
                                  ],
                                  color: notifire.gettabwhitecolor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: _selectedIndex == index
                                        ? Colors.transparent
                                        : notifire.getPrimaryPurpleColor
                                            .withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: height / 15,
                                      width: width / 7,
                                      decoration: BoxDecoration(
                                        color: notifire.gettabwhitecolor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "images/lockdown.png",
                                          height: height / 30,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      paymentMethod[index],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: notifire.getdarkscolor,
                                          fontSize: height / 50,
                                          fontFamily: 'Gilroy Medium'),
                                    ),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),

                    SizedBox(
                      height: height / 40,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Text(
                            "Nominal Withdraw",
                            style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 43,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 20),
                      child: Container(
                        height: height / 7,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: notifire.getPrimaryPurpleColor.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width / 20,
                                ),
                                Text(
                                  "Masukkan nilai",
                                  style: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontFamily: 'Gilroy Medium',
                                    fontSize: height / 50,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: TextFormField(
                                controller: _ctrAmount,
                                style: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontSize: height / 40),
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Rp0",
                                    hintStyle: TextStyle(
                                        fontSize: height / 30,
                                        color: notifire.getdarkgreycolor
                                            .withOpacity(0.4),
                                        fontFamily: 'Gilroy Bold')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // start list amount
                    SizedBox(
                      height: height / 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 20),
                      child: Container(
                        height: height / 25,
                        color: Colors.transparent,
                        child: ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: amount.length,
                          itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(right: width / 30),
                              child: GestureDetector(
                                onTap: () {
                                  _ctrAmount.text = amount[index];
                                },
                                child: Container(
                                  // height: height / 20,
                                  // width: width / 5,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color:
                                        notifire.getPrimaryPurpleColor.withOpacity(0.3),
                                  ),
                                  child: Center(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width / 40),
                                        child: Text(
                                          amount[index],
                                          style: TextStyle(
                                              color: notifire.getPrimaryPurpleColor,
                                              fontFamily: 'Gilroy Bold',
                                              fontSize: height / 60),
                                        )),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                    // end list amount
                  ],
                ),

                // start action
                Positioned(
                    left: 0, // Align to the left side
                    right: 0,
                    bottom: height / 30,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 30),
                      child: Container(
                        width: width,
                        alignment: Alignment.bottomCenter,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: GestureDetector(
                            onTap: () {
                              if (_ctrAmount.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Masukkan nilai!")));
                                  return;
                              }
                              _handleSubmit();
                            },
                            child: scannerbutton(
                              notifire.getPrimaryPurpleColor,
                              "Konfirmasi",
                              Colors.white,
                            )),
                      ),
                    ))
                // end action
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    Loading.showLoadingLogoDialog(context, _globalKey);
    try {
        Map<String, dynamic> body = {
          "amount": Helpers.removeCurrencyFormatter(_ctrAmount.text)
        };

        final response = await ApiClient(AppConfig().configDio(context: context)).postWalletDeposit(
            authorization: 'Bearer ${SharedPrefs().token}', body: body);

        Navigator.pop(context);

        if (response.success) {
           
        } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(response.message)));
        }
    } catch (e) {
      Navigator.pop(context);
      // Fluttertoast.showToast(
      //   msg: e.toString(),
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16,
      // );
      rethrow;
    }
  }

  Widget scannerbutton(clr, txt, clr2) {
    return Container(
      height: height / 18,
      width: width,
      decoration: BoxDecoration(
          color: clr,
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          border: Border.all(color: notifire.getPrimaryPurpleColor)),
      child: Center(
        child: Text(
          txt,
          style: TextStyle(
              color: clr2, fontSize: height / 55, fontFamily: 'Gilroy Bold'),
        ),
      ),
    );
  }
}
