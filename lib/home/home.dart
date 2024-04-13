import 'dart:convert';

import 'package:card_slider/card_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/card/mycard.dart';
import 'package:kumpulpay/category/category.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/home/notifications.dart';
import 'package:kumpulpay/ppob/ppob_product.dart';
import 'package:kumpulpay/home/request/request.dart';
import 'package:kumpulpay/home/scanpay/scan.dart';
import 'package:kumpulpay/home/seealltransaction.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/topup/topup.dart';
import 'package:kumpulpay/utils/color.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helper_data_json.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:kumpulpay/wallet/wallets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/helpsupport.dart';
import '../profile/legalandpolicy.dart';
import 'transfer/sendmoney.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ColorNotifire notifire;

  Map<String, dynamic> userData = jsonDecode(SharedPrefs().userData);

  late double limitsAvailable = 0;
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

  List cashbankimg = [
    "images/cashback.png",
    "images/merchant1.png",
    "images/helpandsupport.png"
  ];
  List cashbankname = [
    CustomStrings.cashback,
    CustomStrings.becomemerchant,
    CustomStrings.helpandsuppors,
  ];
  List cashbankdiscription = [
    CustomStrings.scratchcards,
    CustomStrings.startsccepting,
    CustomStrings.relatedpaytm,
  ];
  List cashbankdiscription2 = [
    CustomStrings.scratchcards2,
    CustomStrings.startsccepting2,
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
            return Center(child: Text('Upst...'));
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

          listFavoritService = snapshot.data["data"]["favorit_sevice"];
          listLastTransaction = snapshot.data["data"]["last_transaction"];

          List<Widget> valuesWidget = [];
          for (int i = 0; i < listCardBalance.length; i++) {
            valuesWidget.add(Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: listCardBalance[i]['color'],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Row(
                      children: [
                        Text(
                          listCardBalance[i]['name'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height / 50,
                              fontFamily: 'Gilroy Medium'),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Image.asset(
                              "images/message1.png",
                              height: height / 25,
                              color: Colors.white,
                            ),
                            Text(
                              listCardBalance[i]['id'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height / 70,
                                  fontFamily: 'Gilroy Medium'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // start balance
                  Padding(
                    padding: EdgeInsets.only(left: width / 20),
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
                                  Helpers.currencyFormatter(
                                      listCardBalance[i]['balance'].toDouble()),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height / 35,
                                      fontFamily: 'Gilroy Bold'),
                                )
                              : Text(
                                  "********",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height / 20,
                                      fontFamily: 'Gilroy Bold'),
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
                                      EdgeInsets.only(bottom: height / 100),
                                  child: Image.asset(
                                    "images/eye.png",
                                    color: Colors.white,
                                    height: height / 40,
                                  ),
                                )
                              : Padding(
                                  padding:
                                      EdgeInsets.only(bottom: height / 100),
                                  child: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                  // end balance
                ],
              ),
            ));
          }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Notificationindex(CustomStrings.notification),
                      ),
                    );
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

                            Padding(
                              padding: EdgeInsets.only(
                                  top: height / 40,
                                  left: width / 50,
                                  right: width / 50),
                              child: Container(
                                height: height / 3.1,
                                child: CardSlider(
                                  // containerHeight: 320,
                                  containerHeight: double.infinity,
                                  cards: valuesWidget,
                                  // bottomOffset: -0.0005,
                                  bottomOffset: -0.001,
                                  // cardHeight: 0.75,
                                  cardHeight: 0.30,
                                  // cardHeightOffset: 0.01,
                                  cardHeightOffset: 0.01,
                                  // itemDotOffset: -0.25,
                                  itemDotOffset: 0,
                                ),
                              ),
                            ),

                            // start card midle action
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: height / 5.4,
                                    left: width / 30,
                                    right: width / 30),
                                // padding: EdgeInsets.symmetric(horizontal: width / 30),
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
                                                        const BorderRadius.all(
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
                                                    fontFamily: "Gilroy Bold",
                                                    color:
                                                        notifire.getdarkscolor,
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
                                                        const BorderRadius.all(
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
                                                    fontFamily: "Gilroy Bold",
                                                    color:
                                                        notifire.getdarkscolor,
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
                                                        const BorderRadius.all(
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
                                                CustomStrings.request,
                                                style: TextStyle(
                                                    fontFamily: "Gilroy Bold",
                                                    color:
                                                        notifire.getdarkscolor,
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
                                                          const Topup(),
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
                                                        const BorderRadius.all(
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
                                                CustomStrings.topup,
                                                style: TextStyle(
                                                    fontFamily: "Gilroy Bold",
                                                    color:
                                                        notifire.getdarkscolor,
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Category(),
                                    ),
                                  );
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
                                  padding: EdgeInsets.only(bottom: height / 15),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: height / 10,
                                    mainAxisExtent: height / 8,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: height / 50,
                                    mainAxisSpacing: height / 40,
                                  ),
                                  itemCount: listFavoritService.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PpobProduct(
                                                type: listFavoritService[index]
                                                    ["category"]),
                                          ),
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
                                                  fontFamily: "Gilroy Bold",
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
                        SizedBox(
                          height: height / 80,
                        ),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Seealltransaction(),
                                    ),
                                  );
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

                        // another actions
                        Container(
                          height: height / 2.5,
                          color: Colors.transparent,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: cashbankname.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20,
                                  vertical: height / 100),
                              child: InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Notificationindex(
                                                CustomStrings.cashback),
                                      ),
                                    );
                                  } else if (index == 1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HelpSupport(
                                          CustomStrings.becomemerchant,
                                        ),
                                      ),
                                    );
                                  } else if (index == 2) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LegalPolicy(
                                            CustomStrings.helps),
                                      ),
                                    );
                                  }
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
                                              cashbankimg[index],
                                              height: height / 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width / 30,
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
                                                  cashbankname[index],
                                                  style: TextStyle(
                                                      fontFamily: "Gilroy Bold",
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
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      cashbankdiscription[
                                                          index],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Gilroy Medium",
                                                          color: notifire
                                                              .getdarkgreycolor
                                                              .withOpacity(0.6),
                                                          fontSize:
                                                              height / 65),
                                                    ),
                                                    Text(
                                                      cashbankdiscription2[
                                                          index],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Gilroy Medium",
                                                          color: notifire
                                                              .getdarkgreycolor
                                                              .withOpacity(0.6),
                                                          fontSize:
                                                              height / 60),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
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

        return Center(child: Text('Upst...'));
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

  // FutureBuilder<dynamic> _buildCetagoryList(BuildContext context) {
  //   final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
  //   final Map<String, dynamic> query = {"type": "home"};
  //   return FutureBuilder<dynamic>(
  //     future: client.getProductCategory('Bearer ${SharedPrefs().token}',
  //         queries: query),
  //     builder: (context, snapshot) {
  //       try {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           List<dynamic> list = snapshot.data["data"];

  //           return Padding(
  //             padding: EdgeInsets.symmetric(horizontal: width / 20),
  //             child: Container(
  //               color: Colors.transparent,
  //               height: height / 3.5,
  //               width: width,
  //               child: Builder(builder: (context) {
  //                 // List<dynamic> child2 = item["child"];
  //                 return GridView.builder(
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     padding: EdgeInsets.only(bottom: height / 15),
  //                     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
  //                       maxCrossAxisExtent: height / 10,
  //                       mainAxisExtent: height / 8,
  //                       childAspectRatio: 3 / 2,
  //                       crossAxisSpacing: height / 50,
  //                       mainAxisSpacing: height / 40,
  //                     ),
  //                     itemCount: list.length,
  //                     itemBuilder: (BuildContext ctx, index) {
  //                       return GestureDetector(
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => const Scan(),
  //                             ),
  //                           );
  //                         },
  //                         child: Column(
  //                           children: [
  //                             Container(
  //                               height: height / 15,
  //                               width: width / 7,
  //                               decoration: BoxDecoration(
  //                                 color: notifire.gettabwhitecolor,
  //                                 borderRadius: const BorderRadius.all(
  //                                   Radius.circular(10),
  //                                 ),
  //                               ),
  //                               child: Center(
  //                                 child: Image.asset(
  //                                   list[index]["image_mobile"],
  //                                   height: height / 30,
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               height: height / 120,
  //                             ),
  //                             Center(
  //                               child: Text(
  //                                 list[index]["name"],
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                     fontFamily: "Gilroy Bold",
  //                                     color: notifire.getdarkscolor,
  //                                     fontSize: height / 60),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     });
  //               }),
  //             ),
  //           );
  //         } else {
  //           return Text("Loading..", textAlign: TextAlign.center);
  //         }
  //       } on DioException catch (e) {
  //         if (e.response != null) {
  //           print(e.response?.data);
  //           print(e.response?.headers);
  //           print(e.response?.requestOptions);
  //         } else {
  //           // Something happened in setting up or sending the request that triggered an Error
  //           print(e.requestOptions);
  //           print(e.message);
  //         }
  //       }

  //       return Text("Loading..", textAlign: TextAlign.center);
  //     },
  //   );
  // }

// Widget week() {
//   return selectedindex == 0
//       ? const ChatScreen()
//       : const ChatRound();
// }
}
