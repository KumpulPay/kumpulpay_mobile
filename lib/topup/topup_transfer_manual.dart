import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/color.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../../utils/colornotifire.dart';
import '../../../utils/media.dart';

class TopupTransferManual extends StatefulWidget {
  const TopupTransferManual({Key? key}) : super(key: key);

  @override
  State<TopupTransferManual> createState() => _TopupTransferManualState();
}

class _TopupTransferManualState extends State<TopupTransferManual> {
  late ColorNotifire notifire;
  int _selectedIndex = 1;
  TextEditingController _ctrAmount = TextEditingController();

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

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
          "Apabila saldo gagal terisi dan pelanggan tidak memberitahu terhitung 3 bulan setelah transfer, maka tidak ada kewajiban bagi Topindoku untuk validasi dan input manual saldo"
    }
  ];

  final List<Map<String,dynamic>> _listBank = [
    {
      "image": "",
      "bank_name": "aa",
      "account_number": "aaa"
    },
    {
      "image": "",
      "bank_name": "aa",
      "account_number": "aaa"
    }
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
        // physics: const NeverScrollableScrollPhysics(),
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
                            "Metode Pembayaran",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 50,
                            ),
                          ),
                        ),
                      ],
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
                                "Rp0",
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
                              child: Text("Total Bayar",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Gilroy Medium',
                                    fontSize: height / 60,
                                  ))),
                          Expanded(
                              flex: 2,
                              child: Text(
                                "Rp0",
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
                    Row(
                      children: [
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
                      ],
                    ),
                    SizedBox(
                      height: height / 70,
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _listPaymentInstructions.length,
                      itemBuilder: (context, index) {
                        return Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 20),
                                child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                _listPaymentInstructions[index]
                                                    ["number"],
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
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
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                          child: Text(
                            "Pilih Bank",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget paymentInstructions(){
  //   return Html
  // }

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
