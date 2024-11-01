import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/bottombar/bottombar.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/transaction/history.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../../utils/colornotifire.dart';
import '../../../utils/media.dart';

class TopupTransferManual extends StatefulWidget {
  static String routeName = '/topup_transfer_manual';
  final dynamic data;
  const TopupTransferManual({Key? key, this.data}) : super(key: key);

  @override
  State<TopupTransferManual> createState() => _TopupTransferManualState();
}

class _TopupTransferManualState extends State<TopupTransferManual> {
  late ColorNotifire notifire;
  TopupTransferManual? args;
  dynamic _data;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  final List<Map<String, dynamic>> _listPaymentInstructions = [
    {
      "number": "1.",
      "text":
          "Nominal transfer harus sesuai dengan jumlah nominal yang harus dibayar"
    },
    {
      "number": "2.",
      "text":
          "Saldo akan masuk sesuai jumlah transfer tanpa dikenakan biaya administrasi, saldo akan masuk otomatis dalam waktu 5-10 menit"
    },
    {
      "number": "3.",
      "text":
          "Pengisian saldo melalui transfer bank dapat dilakukan dari pukul 07.00-20.45 WIB"
    },
    {
      "number": "4.",
      "text":
          "Validasi dan input manual bisa diajukan atas permintaan pelanggan apabila saldo gagal terisi dalam waktu 6 jam terhitung sejak dilakukan transfer"
    },
    {
      "number": "5.",
      "text":
          "Apabila saldo gagal terisi dan pelanggan tidak memberitahu terhitung 3 bulan setelah transfer, maka tidak ada kewajiban bagi KumpulPay untuk validasi dan input manual saldo"
    }
  ];

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as TopupTransferManual?;
    _data = args!.data;
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    print(_data);
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            History.routeName,
            ModalRoute.withName(Bottombar.routeName),
          );
          return;
        },  
        child: Scaffold(
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
              "Transfer Bank",
              style: TextStyle(
                color: notifire.getdarkscolor,
                fontFamily: 'Gilroy Bold',
                fontSize: height / 40,
              ),
            ),
            centerTitle: false,
          ),
          backgroundColor: notifire.getprimerycolor,
          body: SingleChildScrollView(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height / 50,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Text(
                            "Rincian",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 70,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Nominal",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy Medium',
                                        fontSize: height / 60,
                                      ))),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    Helpers.currencyFormatter(
                                        _data['amount'].toDouble()),
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Kode Unik",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy Medium',
                                        fontSize: height / 60,
                                      ))),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    _data['unique'].toString(),
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text("Jumlah Yang Harus Di Transfer",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy Medium',
                                        fontSize: height / 60,
                                      ))),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    Helpers.currencyFormatter(
                                        _data['amount_unique'].toDouble()),
                                    textAlign: TextAlign.end,
                                  )),
                            ],
                          ),
                        ),

                        // line
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: width / 20, horizontal: width / 20),
                          child: const DottedLine(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: Colors.grey,
                          ),
                        ),

                        SizedBox(
                          height: height / 70,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Text(
                            "Instruksi Pembayaran",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 70,
                        ),

                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _listPaymentInstructions.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    _listPaymentInstructions[
                                                        index]["number"],
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          'Gilroy Medium',
                                                      fontSize: height / 60,
                                                    )),
                                              )
                                            ],
                                          )),
                                      Expanded(
                                          flex: 15,
                                          child: Text(
                                              _listPaymentInstructions[index]
                                                  ["text"],
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Gilroy Medium',
                                                fontSize: height / 60,
                                              ))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height / 70,
                                ),
                              ],
                            );
                          },
                        ),

                        // start list bank
                        SizedBox(
                          height: height / 70,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Text(
                            "Pilihan Bank",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 50,
                            ),
                          ),
                        ),

                        FutureBuilder(
                          future: ApiClient(Dio(
                                  BaseOptions(contentType: "application/json")))
                              .getCompanyBank('Bearer ${SharedPrefs().token}'),
                          builder: (context, dynamic snapshot) {
                            // print('print: $snapshot');
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: Text('Please wait its loading...'));
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return _buildAccordion(snapshot.data['data']);
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const Center(child: Text('Upst...'));
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildAccordion(dynamic snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 40),
      child: Accordion(
          disableScrolling: true,
          flipRightIconIfOpen: true,
          contentVerticalPadding: 0,
          scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
          maxOpenSections: 1,
          headerBackgroundColorOpened: Colors.black54,
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          contentBorderColor: notifire.getgreycolor,
          rightIcon: Transform.rotate(
              angle: 45 * 3.14159 / 90,
              child: Icon(Icons.arrow_forward_ios,
                  color: notifire.getdarkscolor, size: height / 50)),
          children: [
            for (var item in snapshot) ...[
              AccordionSection(
                  headerBackgroundColor: notifire.gettabwhitecolor,
                  contentBackgroundColor: notifire.gettabwhitecolor,
                  header: Text(
                    item['bank_datas']['name'],
                    style: TextStyle(
                        fontFamily: "Gilroy Bold",
                        color: notifire.getdarkscolor,
                        fontSize: height / 55),
                  ),
                  content: Builder(builder: (context) {
                    return Container(
                      child: Column(
                        children: [
                          Text(
                            "Transfer pembayaran ke Nomor Rekening",
                            style: TextStyle(
                                fontFamily: "Gilroy Light",
                                color: notifire.getdarkscolor,
                                fontSize: height / 55),
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          Text(
                            item['account_number'],
                            style: TextStyle(
                                fontFamily: "Gilroy Bold",
                                color: notifire.getbluecolor,
                                fontSize: height / 40),
                          ),
                          Text(
                            'a/n:  ${item['account_name']}',
                            style: TextStyle(
                                fontFamily: "Gilroy Light",
                                color: notifire.getdarkscolor,
                                fontSize: height / 55),
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          Text(
                            'Total Transfer',
                            style: TextStyle(
                                fontFamily: "Gilroy Light",
                                color: notifire.getdarkscolor,
                                fontSize: height / 55),
                          ),
                          Text(
                            Helpers.currencyFormatter(
                                _data['amount_unique'].toDouble()),
                            style: TextStyle(
                                fontFamily: "Gilroy Bold",
                                color: notifire.getbluecolor,
                                fontSize: height / 40),
                          ),
                        ],
                      ),
                    );
                  })),
            ]
          ]),
    );
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
