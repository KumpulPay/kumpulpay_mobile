import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/paylater/paylater_invoice.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/color.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/text_style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wallets extends StatefulWidget {
  const Wallets({Key? key}) : super(key: key);

  @override
  State<Wallets> createState() => _WalletsState();
}

class _WalletsState extends State<Wallets> {
  late ColorNotifire notifire;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

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

  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  final int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 7.0,
      width: isActive ? 30.0 : 7.0,
      decoration: BoxDecoration(
        color: isActive
            ? notifire.getbluecolor
            : notifire.getbluecolor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('printX: $_currentPage');
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        title: Text(
          "Saldo",
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
        centerTitle: true,
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
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
                  height: height / 50,
                ),

                FutureBuilder(
                  future: _getPaylaterPeriod(),
                  builder: (context, dynamic snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Text('Please wait its loading...'));
                    } else if (snapshot.connectionState == ConnectionState.done) {  
                       return _buildView(snapshot.data['data']);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: Text('Upst...'));
                    }
                  },
                ),

                // // start view page
                // Container(
                //   color: Colors.transparent,
                //   height: height / 5,
                //   width: width,
                //   child: PageView(
                //     physics: const ClampingScrollPhysics(),
                //     controller: _pageController,
                //     onPageChanged: (int page) {
                //       setState(() {
                //         _currentPage = page;
                //       });
                //     },
                //     children: <Widget>[
                //       // start wallet
                //       Padding(
                //         padding: EdgeInsets.symmetric(
                //           horizontal: width / 20,
                //         ),
                //         child: Container(
                //             height: height / 4,
                //             decoration: BoxDecoration(
                //               color: notifire.getbluecolor,
                //               borderRadius: const BorderRadius.all(
                //                 Radius.circular(20),
                //               ),
                //               image: const DecorationImage(
                //                 opacity: 0.5,
                //                 image: AssetImage(
                //                     'images/backphoto.png'), // Path to your image
                //                 fit: BoxFit
                //                     .cover, // Adjust the image size and aspect ratio
                //               ),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: width / 15,
                //                   vertical: height / 60),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     "Paylater",
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontFamily: 'Gilroy Bold',
                //                       fontSize: height / 50,
                //                     ),
                //                   ),
                //                   Text(
                //                     "Rp500.000",
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontFamily: 'Gilroy Bold',
                //                       fontSize: height / 30,
                //                     ),
                //                   ),
                //                   Text(
                //                     "Total Pemakaian",
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontFamily: 'Gilroy',
                //                       fontSize: height / 60,
                //                     ),
                //                   ),
                                
                //                   const Spacer(),
                //                   Text(
                //                     "PLT-17117511264",
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontFamily: 'Gilroy',
                //                       fontSize: height / 60,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             )),
                //       ),

                //       // start paylater
                //       Padding(
                //         padding: EdgeInsets.symmetric(
                //           horizontal: width / 20,
                //         ),
                //         child: Container(
                //           height: height / 4,
                //           decoration: const BoxDecoration(
                //             color: Colors.transparent,
                //             borderRadius: BorderRadius.all(
                //               Radius.circular(20),
                //             ),
                //           ),
                //           child: ClipRRect(
                //             borderRadius: const BorderRadius.all(
                //               Radius.circular(20),
                //             ),
                //             child: Image.asset(
                //               "images/visa2.png",
                //               height: height / 25,
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: height / 40,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: _buildPageIndicator(),
                // ),
                // // end view page
                
                // SizedBox(
                //   height: height / 40,
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(),
                //   child: Container(
                //       height: height,
                //       width: width,
                //       decoration: const BoxDecoration(
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(20),
                //           topRight: Radius.circular(20),
                //         ),
                //         color: Colors.white,
                //       ),
                //       child: Padding(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: width / 20, vertical: height / 40),
                //         child: Column(
                //           children: [
                //             Row(
                //               children: [
                //                 Expanded(
                //                     flex: 1,
                //                     child: Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       children: [
                //                         textStyleSubTitle("Limit Tersedia"),
                //                         textStyleTitle("Rp-"),
                //                       ],
                //                     )),
                //                 Expanded(
                //                     flex: 1,
                //                     child: Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       children: [
                //                         textStyleSubTitle("Limit"),
                //                         textStyleTitle("Rp-"),
                //                       ],
                //                     ))
                //               ],
                //             ),
                //             SizedBox(
                //               height: 5,
                //             ),
                //             Divider(
                //               thickness: 0.6,
                //               color: Colors.grey.withOpacity(0.4),
                //             ),
                //             SizedBox(
                //               height: 5,
                //             ),
                //             Row(
                //               children: [
                //                 Expanded(
                //                     flex: 1,
                //                     child: Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       children: [
                //                         textStyleSubTitle("Tanggal Jatuh Tempo"),
                //                         textStyleTitle("-"),
                //                       ],
                //                     )),
                //                 Expanded(
                //                     flex: 1,
                //                     child: Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       children: [
                //                         textStyleSubTitle("Status"),
                //                         textStyleTitle("-"),
                //                       ],
                //                     ))
                //               ],
                //             ),

                //             SizedBox(
                //               height: height / 40,
                //             ),
                //             Padding(
                //               padding:
                //                   EdgeInsets.symmetric(),
                //               child: Container(
                //                 width: width,
                //                 alignment: Alignment.bottomCenter,
                //                 decoration: const BoxDecoration(
                //                   borderRadius: BorderRadius.all(
                //                     Radius.circular(20),
                //                   ),
                //                 ),
                //                 child: GestureDetector(
                //                     onTap: () {
                //                       Navigator.push(
                //                         context,
                //                         MaterialPageRoute(
                //                           builder: (context) =>
                //                               const PaylaterInvoice(),
                //                         ),
                //                       );
                //                     },
                //                     child: scannerbutton(
                //                       notifire.getbluecolor,
                //                       "Informasi Tagihan",
                //                       Colors.white,
                //                     )),
                //               ),
                //             )
                //           ],
                //         ),
                //       )),
                // )

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildView(dynamic snapshot){
    // print('print: ${snapshot['limits']}');

    List<Widget> valuesWidget = [];
    valuesWidget.add(Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width / 20,
      ),
      child: Container(
          height: height / 4,
          decoration: BoxDecoration(
            color: notifire.getbluecolor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            image: const DecorationImage(
              opacity: 0.5,
              image: AssetImage('images/backphoto.png'), // Path to your image
              fit: BoxFit.cover, // Adjust the image size and aspect ratio
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 15, vertical: height / 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Periode ${snapshot['period']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy Bold',
                    fontSize: height / 50,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Helpers.currencyFormatter(
                                snapshot['limits_used'].toDouble()),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 30,
                            ),
                          ),
                          Text(
                            "Total Pemakaian",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gilroy',
                              fontSize: height / 60,
                            ),
                          ),
                        ],
                      )
                    ),
                    Expanded(
                      flex: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/message1.png",
                              height: height / 25,
                              color: Colors.white,
                            ),
                            Text(
                              "Paylater",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height / 70,
                                  fontFamily: 'Gilroy Medium'),
                            ),
                          ],
                        )
                    )
                  ],
                ),
                
                const Spacer(),
                Text(
                  "PLT-17117511264",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                    fontSize: height / 60,
                  ),
                ),
              ],
            ),
          )),
    ));
    valuesWidget.add(Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width / 20,
      ),
      child: Container(
          height: height / 4,
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage('images/backphoto.png'), // Path to your image
              fit: BoxFit.cover, // Adjust the image size and aspect ratio
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 15, vertical: height / 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Periode ${snapshot['period']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy Bold',
                    fontSize: height / 50,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Helpers.currencyFormatter(
                                  snapshot['limits_used'].toDouble()),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 30,
                              ),
                            ),
                            Text(
                              "Saldo saat ini",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontSize: height / 60,
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/message1.png",
                              height: height / 25,
                              color: Colors.white,
                            ),
                            Text(
                              "Deposit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height / 70,
                                  fontFamily: 'Gilroy Medium'),
                            ),
                          ],
                        ))
                  ],
                ),
                const Spacer(),
                Text(
                  "PLT-17117511264",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                    fontSize: height / 60,
                  ),
                ),
              ],
            ),
          )),
    ));

    return Column(
      children: [
        // start view page
        Container(
          color: Colors.transparent,
          height: height / 5,
          width: width,
          child: PageView.builder(
            itemCount: valuesWidget.length,
            onPageChanged: (value) {
              print('onPageChanged: $value');
            },
            itemBuilder: (context, index) {
              return valuesWidget[index];
            },
          ),
          // PageView(
          //   physics: const ClampingScrollPhysics(),
          //   controller: _pageController,
          //   onPageChanged: (int page) {
          //     print('printY: ${_currentPage}');
          //     setState(() {
          //       _currentPage = page;
          //       print('print: ${_currentPage}');
          //     });
          //   },
          //   children: <Widget>[
          //     // start wallet
          //     Padding(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: width / 20,
          //       ),
          //       child: Container(
          //           height: height / 4,
          //           decoration: BoxDecoration(
          //             color: notifire.getbluecolor,
          //             borderRadius: const BorderRadius.all(
          //               Radius.circular(20),
          //             ),
          //             image: const DecorationImage(
          //               opacity: 0.5,
          //               image: AssetImage(
          //                   'images/backphoto.png'), // Path to your image
          //               fit: BoxFit
          //                   .cover, // Adjust the image size and aspect ratio
          //             ),
          //           ),
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: width / 15, vertical: height / 60),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   "Periode ${snapshot['period']}",
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontFamily: 'Gilroy Bold',
          //                     fontSize: height / 50,
          //                   ),
          //                 ),
          //                 Text(
          //                   Helpers.currencyFormatter(
          //                       snapshot['limits_used'].toDouble()),
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontFamily: 'Gilroy Bold',
          //                     fontSize: height / 30,
          //                   ),
          //                 ),
          //                 Text(
          //                   "Total Pemakaian",
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontFamily: 'Gilroy',
          //                     fontSize: height / 60,
          //                   ),
          //                 ),
          //                 const Spacer(),
          //                 Text(
          //                   "PLT-17117511264",
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontFamily: 'Gilroy',
          //                     fontSize: height / 60,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           )),
          //     ),

          //     // start paylater
          //     Padding(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: width / 20,
          //       ),
          //       child: Container(
          //         height: height / 4,
          //         decoration: const BoxDecoration(
          //           color: Colors.transparent,
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(20),
          //           ),
          //         ),
          //         child: ClipRRect(
          //           borderRadius: const BorderRadius.all(
          //             Radius.circular(20),
          //           ),
          //           child: Image.asset(
          //             "images/visa2.png",
          //             height: height / 25,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
        SizedBox(
          height: height / 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicator(),
        ),
        // end view page

        SizedBox(
          height: height / 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(),
          child: Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width / 20, vertical: height / 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textStyleSubTitle("Limit Tersedia"),
                                textStyleTitle(Helpers.currencyFormatter(
                                    snapshot['limits_available'].toDouble())),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textStyleSubTitle("Limit"),
                                textStyleTitle(Helpers.currencyFormatter(snapshot['limits'].toDouble())),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(
                      thickness: 0.6,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textStyleSubTitle("Tanggal Jatuh Tempo"),
                                textStyleTitle("-"),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textStyleSubTitle("Status"),
                                textStyleTitle("-"),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PaylaterInvoice(),
                                    ),
                                  );
                                },
                                child: scannerbutton(
                                  notifire.getbluecolor,
                                  "Transaksi Terbuku",
                                  Colors.white,
                                ))
                        ),
                        SizedBox(
                          width: width / 40,
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PaylaterInvoice(),
                                    ),
                                  );
                                },
                                child: scannerbutton(
                                  notifire.getbluecolor,
                                  "Informasi Tagihan",
                                  Colors.white,
                                ))
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(),
                    //   child: Container(
                    //     width: width,
                    //     alignment: Alignment.bottomCenter,
                    //     decoration: const BoxDecoration(
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(20),
                    //       ),
                    //     ),
                    //     child: GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => const PaylaterInvoice(),
                    //             ),
                    //           );
                    //         },
                    //         child: scannerbutton(
                    //           notifire.getbluecolor,
                    //           "Informasi Tagihan",
                    //           Colors.white,
                    //         )),
                    //   ),
                    // )
                  ],
                ),
              )),
        )
      ],
    );
  }

  Future<dynamic> _getPaylaterPeriod() async {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    return await client.getPaylaterPeriod('Bearer ${SharedPrefs().token}');
  }

  Widget scannerbutton(clr, txt, clr2) {
    return Container(
      height: height / 25,
      width: width,
      decoration: BoxDecoration(
          color: clr,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: notifire.getbluecolor)),
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
