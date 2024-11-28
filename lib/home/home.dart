import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kumpulpay/category/category.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/notification/notification_list.dart';
import 'package:kumpulpay/ppob/ppob_postpaid_single_provider.dart';
import 'package:kumpulpay/ppob/ppob_product.dart';
import 'package:kumpulpay/home/request/request.dart';
import 'package:kumpulpay/home/scanpay/scan.dart';
import 'package:kumpulpay/ppob/product_provider.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/topup/topup.dart';
import 'package:kumpulpay/transaction/history_all.dart';
import 'package:kumpulpay/utils/color.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helper_data_json.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../profile/helpsupport.dart';
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
  late bool _loading = true;
  late double limitsAvailable = 0;
  late double balanceAvailable = 0;
  List<dynamic> listFavoritService = [];
  List<dynamic> listLastTransaction = [];

  @override
  void initState() {
    super.initState();

    listFavoritService = List.filled(7, {
      "category_images": {
        "image": "images/logo_app/disabled_kumpulpay_logo.png"
      },
      "category_name": "item1",
      "category_short_name": "item1",
    });
    
    _getDataHome();
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

  List<Map<String, dynamic>> exclusiveItems = [
    {'title': "Iuran Lingkungan", 'image': 'images/ic_kumpulpay/iuran_lingkungan.png'},
    {'title': "Iuran Komunitas", 'image': 'images/ic_kumpulpay/iuran_komunitas.png'},
    {'title': "Iuran Pendidikan", 'image': 'images/ic_kumpulpay/iuran_pendidikan.png'},
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
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
              userData["name"],
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontSize: 20,
                  fontFamily: 'Gilroy Bold'),
            ),
          ],
        ),
        actions: [
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const MyCard(),
          //       ),
          //     );
          //   },
          //   child: Image.asset(
          //     "images/message1.png",
          //     color: notifire.getdarkscolor,
          //     scale: 4,
          //   ),
          // ),
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
                  // start section top
                  _buildSectionTop(),
                  // end section top

                  _exclusiveService(),

                  // start grid menu
                  _favoriteServices(),
                  // end grid menu

                  // start last transaction
                  if (listLastTransaction.isNotEmpty) _buildLastTransaction(),
                  // end last transaction

                  // start another actions
                  _buildAnotherAction(),
                  // end another actions
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTop() {
    return Skeletonizer(
      enabled: _loading,
        child: Stack(
      children: [
        // start top background
        Container(
            height: height / 4,
            width: width,
            color: notifire.getbackcolor,
            child: Image.asset("images/backphoto.png", fit: BoxFit.cover)),
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
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: lightPrimaryPurpleColor,
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
                  color: notifire.getPrimaryPurpleColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 40,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 20),
                      child: Row(
                        children: [
                          Text(
                            "Saldo Saat Ini",
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
                                color: Colors.white,
                                height: height / 25,
                              ),
                              Text(
                                "Saldo",
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
                                    Helpers.currencyFormatter(balanceAvailable),
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
                        color: notifire.getPrimaryPurpleColor.withOpacity(0.4),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Scan(),
                                    ),
                                  );
                                },
                                child: Container(
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
                                      "images/ic_kumpulpay/scanqr.png",
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
                                    color: notifire.getdarkscolor,
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
                                      builder: (context) => const SendMoney(),
                                    ),
                                  );
                                },
                                child: Container(
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
                                      "images/ic_kumpulpay/transfer.png",
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
                                    color: notifire.getdarkscolor,
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
                                      builder: (context) => const Request(),
                                    ),
                                  );
                                },
                                child: Container(
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
                                      "images/ic_kumpulpay/withdraw.png",
                                      height: height / 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 60,
                              ),
                              Text(
                                "Withdraw",
                                style: TextStyle(
                                    fontFamily: "Gilroy Bold",
                                    color: notifire.getdarkscolor,
                                    fontSize: height / 55),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, Topup.routeName);
                                },
                                child: Container(
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
                                      "images/ic_kumpulpay/deposit.png",
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
                                    fontFamily: "Gilroy Bold",
                                    color: notifire.getdarkscolor,
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
    ));
  }

  Widget _exclusiveService() {
    return Skeletonizer(
      enabled: _loading,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height / 40,
            ),
            Padding(
              padding: EdgeInsets.only(left: width / 18),
              child: Row(
                children: [
                  Text(
                    'Hanya di ',
                    style: TextStyle(
                      fontFamily: "Gilroy Bold",
                      color: notifire.getdarkscolor,
                      fontSize: height / 40,
                    ),
                  ),
                  Text(
                    'KumpulPay',
                    style: TextStyle(
                      fontFamily: "Gilroy Bold",
                      color: notifire.getPrimaryPurpleColor,
                      fontSize: height / 40,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height / 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: SizedBox(
                height: height / 7, // Batasi tinggi untuk daftar horizontal
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: height / 30),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Jumlah item per baris
                    crossAxisSpacing:
                        height / 50, // Jarak horizontal antar item
                    mainAxisSpacing: height / 100, // Jarak vertikal antar item
                    childAspectRatio: 1, // Rasio aspek item (lebar:tinggi)
                  ),
                  itemCount: exclusiveItems.length, // Jumlah total item
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Aksi saat item diklik
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: width / 30), // Spasi antar item
                        child: Column(
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
                                  exclusiveItems[index]
                                      ["image"], // Gunakan icon dinamis
                                  height: height / 30,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 120,
                            ),
                            Center(
                              child: Text(
                                exclusiveItems[index]
                                    ["title"], // Gunakan label dinamis
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Gilroy Medium",
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 60,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _favoriteServices() {
    return Skeletonizer(
        enabled:  _loading,
        child: Column(
      children: [
        SizedBox(
          height: height / 40,
        ),
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
                        color: notifire.getPrimaryPurpleColor,
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
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: height / 10,
                    mainAxisExtent: height / 8,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: height / 50,
                    mainAxisSpacing: height / 100,
                  ),
                  itemCount: listFavoritService.length + 1,
                  itemBuilder: (BuildContext ctx, index) {
                    if (index == listFavoritService.length) {
                      return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Category.routeName);
                            },
                            child: Column(
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
                                      "images/ic_kumpulpay/view_more.png",
                                      height: height / 30,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 120,
                                ),
                                Center(
                                  child: Text(
                                    "Lainnya",
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
                    }
                    return GestureDetector(
                      onTap: () {
                        if (listFavoritService[index]['type'] == 'prepaid') {
                          dynamic categoryData = {
                            "id": listFavoritService[index]['category'],
                            "name": listFavoritService[index]['category_name'],
                            "short_name": listFavoritService[index]['category_short_name'],
                            "images": listFavoritService[index]['category_images']
                          };
                          Navigator.pushNamed(
                              context, PpobProduct.routeName,
                              arguments: PpobProduct(
                                  type: listFavoritService[index]['type'],
                                  categoryData: categoryData));
                        } else if (listFavoritService[index]['type'] == 'postpaid') {
                          if (listFavoritService[index]['count_provider'] > 1) {
                            Navigator.pushNamed(
                                context, ProductProvider.routeName,
                                arguments: ProductProvider(
                                    type: listFavoritService[index]['type'],
                                    typeName: listFavoritService[index]['type_name'],
                                    category: listFavoritService[index]['category'],
                                    categoryName: listFavoritService[index]['category_name']));
                          } else {
                            Navigator.pushNamed(context,
                                PpobPostpaidSingleProvider.routeName,
                                arguments: PpobPostpaidSingleProvider(
                                    type: listFavoritService[index]['type'],
                                    typeName: listFavoritService[index]['type_name'],
                                    category: listFavoritService[index]['category'],
                                    categoryName: listFavoritService[index]['category_name'],
                                    child: listFavoritService[index]['child']));
                          }
                        } else if (listFavoritService[index]['type'] == 'entertainment') {
                          Navigator.pushNamed(
                              context, PpobProduct.routeName,
                              arguments: PpobProduct(
                                  type: listFavoritService[index]['type'],
                                  categoryData: listFavoritService[index]));
                        }
                      },
                      child: Column(
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
                              child: _loading
                                      ? Image.asset(
                                          "images/logo_app/disabled_kumpulpay_logo.png", // Gambar fallback jika provider_images null atau kosong
                                          height: height / 30,
                                        )
                                      : _setImage(
                                          listFavoritService[index]['category_images']),
                            ),
                          ),
                          SizedBox(
                            height: height / 120,
                          ),
                          Center(
                            child: Text(
                              listFavoritService[index]["category_short_name"],
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
      ],
    ));
  }
  
  Widget _buildAnotherAction() {
    return Skeletonizer(
        enabled: _loading,
        child: Column(
      children: [
        Container(
          height: height / 2.5,
          color: Colors.transparent,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: anotherActionTxt.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 20, vertical: height / 100),
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
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Row(
                      children: [
                        Container(
                          height: height / 15,
                          width: width / 8,
                          decoration: BoxDecoration(
                            color: notifire.gettabwhitecolor,
                            borderRadius: const BorderRadius.all(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 70,
                              ),
                              Row(
                                children: [
                                  Text(
                                    anotherActionTxt[index],
                                    style: TextStyle(
                                        fontFamily: "Gilroy Bold",
                                        color: notifire.getdarkscolor,
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
                                    color: notifire.getdarkgreycolor
                                        .withOpacity(0.6),
                                    fontSize: height / 65),
                              ),
                            ],
                          ),
                        ),
                        // const Spacer(),
                        Icon(Icons.arrow_forward_ios,
                            color: notifire.getdarkscolor, size: height / 40),
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
    ));
  }

  Widget _buildLastTransaction() {
    return Column(
      children: [
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
                  Navigator.pushNamed(context, HistoryAll.routeName);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Text(
                    CustomStrings.seeall,
                    style: TextStyle(
                        fontFamily: "Gilroy Bold",
                        color: notifire.getPrimaryPurpleColor,
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
          color: Colors.transparent,
          child: Column(
            children: List.generate(
              listLastTransaction.length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width / 20,
                  vertical: height / 100,
                ),
                child: Container(
                  height: height / 11,
                  width: width,
                  decoration: BoxDecoration(
                    color: notifire.getdarkwhitecolor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 30),
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
                            child: listLastTransaction[index]["product_meta"]
                                        ['provider_images'] !=
                                    null
                                ? Helpers.setCachedNetworkImage(
                                    listLastTransaction[index]["product_meta"]
                                        ['provider_images']['image'],
                                    height_: height / 26
                                  )
                                : Image.asset(
                                    "images/logo_app/disabled_kumpulpay_logo.png",
                                    height: height / 20,
                                  ),
                          ),
                        ),
                        SizedBox(width: width / 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              HelpersDataJson.product(
                                  listLastTransaction[index]["product_meta"],
                                  "product_name"),
                              style: TextStyle(
                                fontFamily: "Gilroy Bold",
                                color: notifire.getdarkscolor,
                                fontSize: height / 52,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              Helpers.dateTimeToFormat(
                                listLastTransaction[index]["updated_at"],
                                format: "d MMM y",
                              ),
                              style: TextStyle(
                                fontFamily: "Gilroy Medium",
                                color:
                                    notifire.getdarkgreycolor.withOpacity(0.6),
                                fontSize: height / 60,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(flex: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Helpers.currencyFormatter(
                                listLastTransaction[index]["price_fixed_view"].toDouble(),
                              ),
                              style: TextStyle(
                                fontFamily: "Gilroy Bold",
                                color: listLastTransaction[index]['price_fixed_view'] > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: height / 52,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              listLastTransaction[index]["code"],
                              style: TextStyle(
                                fontFamily: "Gilroy Medium",
                                color:
                                    notifire.getdarkgreycolor.withOpacity(0.6),
                                fontSize: height / 60,
                              ),
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
        )

      ],
    );
  }

  Widget _setImage(dynamic images) {
    return Center(
      child: images != null && images.isNotEmpty
          ? Image.network(
              images['image'], // URL gambar dari API
              height: height / 30,
              // width: width / 8,
              fit: BoxFit
                  .contain, // Menyesuaikan ukuran gambar di dalam container
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika gambar gagal dimuat
                return Image.asset(
                  "images/logo_app/disabled_kumpulpay_logo.png", // Gambar fallback
                  height: height / 30,
                );
              },
            )
          : Image.asset(
              "images/logo_app/disabled_kumpulpay_logo.png", // Gambar fallback jika provider_images null atau kosong
              height: height / 30,
            ),
    );
  }

  void _getDataHome() async {

    final client = ApiClient(AppConfig().configDio());
    final response = await client.getHome(authorization: 'Bearer ${SharedPrefs().token}');

    try {
      if (response.success) {
        setState(() {
          balanceAvailable = response.data["balance"].toDouble();
          SharedPrefs().balanceAvailable = balanceAvailable;

          listFavoritService = response.data["favorit_sevice"];
          listLastTransaction = response.data["last_transaction"];
          _loading = false;
        });
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
