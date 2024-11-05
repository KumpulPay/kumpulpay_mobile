import 'dart:convert';

import 'package:card_slider/card_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/card/mycard.dart';
import 'package:kumpulpay/category/category.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/home/notifications.dart';
import 'package:kumpulpay/notification/notification_list.dart';
import 'package:kumpulpay/ppob/ppob_product.dart';
import 'package:kumpulpay/home/request/request.dart';
import 'package:kumpulpay/home/scanpay/scan.dart';
import 'package:kumpulpay/home/seealltransaction.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/topup/topup.dart';
import 'package:kumpulpay/transaction/history.dart';
import 'package:kumpulpay/utils/color.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helper_data_json.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/helpsupport.dart';
import '../profile/legalandpolicy.dart';
import 'transfer/sendmoney.dart';

class Home extends StatefulWidget {
  static String routeName = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ColorNotifire notifire;

  Map<String, dynamic> userData = jsonDecode(SharedPrefs().userData);

  late double limitsAvailable = 0;
  late double balanceAvailable = 0;
  List<dynamic> listFavoritService = [];
  List<dynamic> listLastTransaction = [];

  @override
  void initState() {
    super.initState();
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

  List transaction = [
    "images/starbuckscoffee.png",
    "images/spotify.png",
    "images/netflix.png"
  ];

  List anotherActionImg = [
    // "images/cashback.png",
    // "images/merchant1.png",
    "images/helpandsupport.png"
  ];
  List anotherActionID = [
    // CustomStrings.cashback,
    // CustomStrings.becomemerchant,
    "help",
  ];
  List anotherActionTxt = [
    // CustomStrings.cashback,
    // CustomStrings.becomemerchant,
    CustomStrings.helpandsuppors,
  ];
  List anotherActionDesc = [
    // CustomStrings.scratchcards,
    // CustomStrings.startsccepting,
    CustomStrings.relatedpaytm,
  ];
  List anotherActionDesc2 = [
    // CustomStrings.scratchcards2,
    // CustomStrings.startsccepting2,
    CustomStrings.relatedpaytm2,
  ];
  bool selection = true;

  List<dynamic> listCardBalance = [
    {
      "id": "paylater",
      "name": "Limit Paylater",
      "color": blueColor,
      "balance": 0,
    },
    {
      "id": "deposit",
      "name": "Saldo Deposit",
      "color": const Color(0xff8978fa),
      "balance": 0,
    }
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return FutureBuilder<dynamic>(
      future: _getDataHome(), // function where you call your api
      builder: (BuildContext context, dynamic snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Please wait its loading...'));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const Center(child: Text('Upst...'));
          }

          if (snapshot.data["data"]["paylater"] != null) {
            listCardBalance.removeWhere((element) => element['id'] == 'paylater');
            limitsAvailable = snapshot.data["data"]["paylater"]
                    ["limits_available"]
                .toDouble();
            SharedPrefs().limitsAvailable = limitsAvailable;

            listCardBalance.add({
              "id": "paylater",
              "name": "Limit Paylater",
              "color": blueColor,
              "balance": limitsAvailable,
            });
          }

          balanceAvailable = snapshot.data["data"]["balance"].toDouble();
          SharedPrefs().balanceAvailable = balanceAvailable;

          listFavoritService = snapshot.data["data"]["favorit_sevice"];
          listLastTransaction = snapshot.data["data"]["last_transaction"];

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: notifire.getprimerycolor,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CustomStrings.goodmorning,
                    style: TextStyle(
                        color: notifire.getdarkgreycolor,
                        fontSize: 14,
                        fontFamily: 'Gilroy Medium'),
                  ),
                  Text(
                    // CustomStrings.hello,
                    userData["name"],
                    style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontSize: 20,
                        fontFamily: 'Gilroy Bold'),
                  ),
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCard(),
                      ),
                    );
                  },
                  child: Image.asset(
                    "images/message1.png",
                    color: notifire.getdarkscolor,
                    scale: 4,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, NotificationList.routeName);
                  },
                  child: Image.asset(
                    "images/notification.png",
                    color: notifire.getdarkscolor,
                    scale: 4,
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            backgroundColor: notifire.getprimerycolor,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // start top background
                            Container(
                                height: height / 4,
                                width: width,
                                color: notifire.getbackcolor,
                                child: Image.asset("images/backphoto.png",
                                    fit: BoxFit.cover)),
                            // end top background

                            Column(
                              children: [
                                SizedBox(
                                  height: height / 40,
                                ),
                                Center(
                                  child: Container(
                                    height: height / 35,
                                    width: width / 1.5,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      color: Color(0xff8978fa),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: height / 7,
                                    width: width / 1.2,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      color: notifire.getbluecolor,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: height / 40,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Saldo Saat Ini",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: height / 50,
                                                    fontFamily:
                                                        'Gilroy Medium'),
                                              ),
                                              const Spacer(),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "images/message1.png",
                                                    color: Colors.white,
                                                    height: height / 25,
                                                  ),
                                                  Text(
                                                    "Saldo",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: height / 70,
                                                        fontFamily:
                                                            'Gilroy Medium'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: width / 20),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: height / 20,
                                                width: width / 2.4,
                                                color: selection
                                                    ? Colors.transparent
                                                    : Colors.transparent,
                                                child: selection
                                                    ? Text(
                                                        Helpers.currencyFormatter(balanceAvailable),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                height / 35,
                                                            fontFamily:
                                                                'Gilroy Bold'),
                                                      )
                                                    : Text(
                                                        "********",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                height / 20,
                                                            fontFamily:
                                                                'Gilroy Bold'),
                                                      ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selection = !selection;
                                                  });
                                                },
                                                child: selection
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: height /
                                                                    100),
                                                        child: Image.asset(
                                                          "images/eye.png",
                                                          color: Colors.white,
                                                          height: height / 40,
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: height /
                                                                    100),
                                                        child: const Icon(
                                                          Icons.remove_red_eye,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                // start card midle action
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width / 30),
                                    child: Container(
                                      height: height / 7,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: notifire.getdarkwhitecolor,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: notifire.getbluecolor
                                                .withOpacity(0.4),
                                            blurRadius: 15.0,
                                            offset: const Offset(0.0, 0.75),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: height / 50,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Scan(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: height / 15,
                                                      width: width / 7,
                                                      decoration: BoxDecoration(
                                                        color: notifire
                                                            .gettabwhitecolor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Image.asset(
                                                          "images/scanpay.png",
                                                          height: height / 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height / 60,
                                                  ),
                                                  Text(
                                                    CustomStrings.scanpay,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Gilroy Bold",
                                                        color: notifire
                                                            .getdarkscolor,
                                                        fontSize: height / 55),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SendMoney(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: height / 15,
                                                      width: width / 7,
                                                      decoration: BoxDecoration(
                                                        color: notifire
                                                            .gettabwhitecolor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Image.asset(
                                                          "images/transfer.png",
                                                          height: height / 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height / 60,
                                                  ),
                                                  Text(
                                                    CustomStrings.transfer,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Gilroy Bold",
                                                        color: notifire
                                                            .getdarkscolor,
                                                        fontSize: height / 55),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Request(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: height / 15,
                                                      width: width / 7,
                                                      decoration: BoxDecoration(
                                                        color: notifire
                                                            .gettabwhitecolor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Image.asset(
                                                          "images/request.png",
                                                          height: height / 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height / 60,
                                                  ),
                                                  Text(
                                                    "Tarik Tunai",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Gilroy Bold",
                                                        color: notifire
                                                            .getdarkscolor,
                                                        fontSize: height / 55),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          Topup.routeName);
                                                    },
                                                    child: Container(
                                                      height: height / 15,
                                                      width: width / 7,
                                                      decoration: BoxDecoration(
                                                        color: notifire
                                                            .gettabwhitecolor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Image.asset(
                                                          "images/topup.png",
                                                          height: height / 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height / 60,
                                                  ),
                                                  Text(
                                                    "Deposit",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Gilroy Bold",
                                                        color: notifire
                                                            .getdarkscolor,
                                                        fontSize: height / 55),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // end card midle action
                              ],
                            ),
                            
                          ],
                        ),
                        SizedBox(
                          height: height / 40,
                        ),

                        // start title grid
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 18),
                          child: Row(
                            children: [
                              Text(
                                CustomStrings.discoverservices,
                                style: TextStyle(
                                    fontFamily: "Gilroy Bold",
                                    color: notifire.getdarkscolor,
                                    fontSize: height / 40),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, Category.routeName);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Text(
                                    CustomStrings.seeall,
                                    style: TextStyle(
                                        fontFamily: "Gilroy Bold",
                                        color: notifire.getbluecolor,
                                        fontSize: height / 45),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // start grid menu
                        SizedBox(
                          height: height / 50,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Container(
                            color: Colors.transparent,
                            // height: height / 3.5,
                            width: width,
                            child: Builder(builder: (context) {
                              return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(bottom: height / 30),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: height / 10,
                                    mainAxisExtent: height / 8,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: height / 50,
                                    mainAxisSpacing: height / 100,
                                  ),
                                  itemCount: listFavoritService.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          PpobProduct.routeName,
                                          arguments: PpobProduct(
                                                type:listFavoritService[index]
                                                    ["name_unique"],
                                                categoryData:
                                                    listFavoritService[index]
                                          )
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: height / 15,
                                            width: width / 7,
                                            decoration: BoxDecoration(
                                              color: notifire.gettabwhitecolor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                listFavoritService[index]
                                                    ["image_mobile"],
                                                height: height / 30,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height / 120,
                                          ),
                                          Center(
                                            child: Text(
                                              listFavoritService[index]["name"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Gilroy Medium",
                                                  color: notifire.getdarkscolor,
                                                  fontSize: height / 60),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }),
                          ),
                        ),
                        // end grid menu

                        // start last transaction
                        // SizedBox(
                        //   height: height / 80,
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 18),
                          child: Row(
                            children: [
                              Text(
                                CustomStrings.lasttransaction,
                                style: TextStyle(
                                    fontFamily: "Gilroy Bold",
                                    color: notifire.getdarkscolor,
                                    fontSize: height / 40),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, History.routeName);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Text(
                                    CustomStrings.seeall,
                                    style: TextStyle(
                                        fontFamily: "Gilroy Bold",
                                        color: notifire.getbluecolor,
                                        fontSize: height / 45),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 50,
                        ),
                        Container(
                          height: height / 3,
                          color: Colors.transparent,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: listLastTransaction.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20,
                                  vertical: height / 100),
                              child: Container(
                                height: height / 11,
                                width: width,
                                decoration: BoxDecoration(
                                  color: notifire.getdarkwhitecolor,
                                  // border: Border.all(
                                  //   color: Colors.grey.withOpacity(0.2),
                                  // ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 30),
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
                                            "images/no-image-2.png",
                                            height: height / 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 40,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: height / 70,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                HelpersDataJson.product(
                                                    listLastTransaction[index]
                                                        ["product_meta"],
                                                    "product_name"),
                                                style: TextStyle(
                                                    fontFamily: "Gilroy Bold",
                                                    color:
                                                        notifire.getdarkscolor,
                                                    fontSize: height / 52),
                                              ),
                                              // SizedBox(width: width / 7,),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height / 100,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                Helpers.dateTimeToFormat(
                                                    listLastTransaction[index]
                                                        ["updated_at"],
                                                    format: "d MMM y"),
                                                style: TextStyle(
                                                    fontFamily: "Gilroy Medium",
                                                    color: notifire
                                                        .getdarkgreycolor
                                                        .withOpacity(0.6),
                                                    fontSize: height / 60),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(flex: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: height / 70,
                                          ),
                                          Text(
                                            listLastTransaction[index]
                                                ["product_price_fixed"],
                                            style: TextStyle(
                                                fontFamily: "Gilroy Bold",
                                                // color: transactioncolor[index],
                                                fontSize: height / 45),
                                          ),
                                          SizedBox(
                                            height: height / 100,
                                          ),
                                          Text(
                                            listLastTransaction[index]["code"],
                                            style: TextStyle(
                                                fontFamily: "Gilroy Medium",
                                                color: notifire.getdarkgreycolor
                                                    .withOpacity(0.6),
                                                fontSize: height / 60),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // start another actions
                        Container(
                          height: height / 2.5,
                          color: Colors.transparent,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: anotherActionTxt.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20,
                                  vertical: height / 100),
                              child: InkWell(
                                onTap: () {
                                  if (anotherActionID[index] == "help") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HelpSupport(
                                          CustomStrings.becomemerchant,
                                        ),
                                      ),
                                    );
                                    
                                  } 
                                  // else if (index == 1) {
                                  //   Navigator.pushNamed(
                                  //       context, NotificationList.routeName);
                                  // } else if (index == 2) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => const LegalPolicy(
                                  //           CustomStrings.helps),
                                  //     ),
                                  //   );
                                  // }
                                },
                                child: Container(
                                  height: height / 9,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: notifire.getdarkwhitecolor,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width / 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: height / 15,
                                          width: width / 8,
                                          decoration: BoxDecoration(
                                            color: notifire.gettabwhitecolor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              anotherActionImg[index],
                                              height: height / 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width / 30,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: height / 70,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    anotherActionTxt[index],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Gilroy Bold",
                                                        color: notifire
                                                            .getdarkscolor,
                                                        fontSize: height / 50),
                                                  ),
                                                  // SizedBox(width: width / 7,),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height / 100,
                                              ),
                                              Text(
                                                "Butuh Bantuan Konsultasi? Jangan ragu untuk menghubungi kami.",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: "Gilroy Medium",
                                                    color: notifire
                                                        .getdarkgreycolor
                                                        .withOpacity(0.6),
                                                    fontSize: height / 65),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // const Spacer(),
                                        Icon(Icons.arrow_forward_ios,
                                            color: notifire.getdarkscolor,
                                            size: height / 40),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 20,
                        ),
                        // end another actions
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return const Center(child: Text('Upst...'));
      },
    );
  }

  Future<dynamic> _getDataHome() async {
    try {
      final client =
          ApiClient(Dio(BaseOptions(contentType: "application/json")));

      return await client.getHome('Bearer ${SharedPrefs().token}');
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response?.data);
        // print(e.response?.headers);
        // print(e.response?.requestOptions);
        bool status = e.response?.data["status"];
        if (status) {
          // return Center(child: Text('Upst...'));
          return e.response;
        }
      } else {
        // print(e.requestOptions);
        // print(e.message);
      }
      rethrow;
    }
  }

}
