import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/phone_provider.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/transaction/confirm_pin.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PpobTransaction extends StatefulWidget {
  final String? type;
  const PpobTransaction({Key? key, this.type}) : super(key: key);

  @override
  State<PpobTransaction> createState() => _PpobTransactionState();
}

class _PpobTransactionState extends State<PpobTransaction>
    with SingleTickerProviderStateMixin, ChangeNotifier {

  final _globalKey = GlobalKey<State>();
  late ColorNotifire notifire;
  Map<String, dynamic> phoneProvider = {};

  bool _validateDestination = false;
  final TextEditingController _ctrDestination = TextEditingController();
  final FocusNode _focusDestination = FocusNode();
  String _txtDestination = "";
  String? _errorDestination;

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submitForm(type) {
    if (_txtDestination.isEmpty) {
        _validateDestination = true;
        _errorDestination = "Wajib diisi";
        phoneProvider.clear();
    } else {
      if (_txtDestination.length < 9) {
        _validateDestination = true;
        _errorDestination = "Minimal 9 karakter";
        phoneProvider.clear();
      } else {
        _validateDestination = false;
        _errorDestination = "";
        if (type == "submit") {
          _focusDestination.unfocus();
          phoneProvider = PhoneProvider.getProvide(_txtDestination);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          "${widget.type}",
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child:
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: height,
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

                      //start input destination
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 20),
                        child: Container(
                          color: Colors.transparent,
                          width: width,
                          height: height / 15,
                          child: TextField(
                            controller: _ctrDestination,
                            focusNode: _focusDestination,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                 _txtDestination = value;
                                 _submitForm("change");
                              });
                            },
                            onSubmitted: (value) {
                             setState(() {
                               _submitForm("submit");
                             });
                            },

                            autofocus: false,
                            style: TextStyle(
                              fontSize: height / 50,
                              color: notifire.getdarkscolor,
                            ),
                            decoration: InputDecoration(
                              errorText: _validateDestination ? _errorDestination : null,
                              hintText: "Input nomor..",
                              filled: true,
                              fillColor: notifire.getprimerydarkcolor,
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: height / 60),
                              suffixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 50,
                                    vertical: height / 60),
                                child: Image.asset(
                                  "images/ic_contact.png",
                                  color: notifire.getdarkgreycolor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: notifire.getbluecolor),
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
                      // end input destination

                      SizedBox(
                        height: height / 50,
                      ),

                      _buildList(context),

                      SizedBox(
                        height: height / 50,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        
      ),
    );
  }

  FutureBuilder<dynamic> _buildList(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    final Map<String, dynamic> queries = {
      "type": "prepaid",
      "category": widget.type
    };
    if (phoneProvider.containsKey("provider")) {
        phoneProvider.remove("icon");
        phoneProvider.remove("prefix");
        queries.addAll(phoneProvider);
    }

    return FutureBuilder<dynamic>(
        future: client.getProductProvider('Bearer ${SharedPrefs().token}',
            queries: queries),
        builder: (context, snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.done) {
              List<dynamic> list = snapshot.data["data"];
              
              if (list.length == 1) {
                List<dynamic> listDetail = list[0]["child"];

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Container(
                    color: Colors.transparent,
                    // height: height / 3.5,
                    width: width,
                    child: Builder(builder: (context) {
                      return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                               const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columns
                                crossAxisSpacing: 10.0, // Spacing between columns
                                mainAxisSpacing: 10.0, // Spacing between rows
                                childAspectRatio: 2.0
                          ),
                          itemCount: listDetail.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    backgroundColor: notifire.getprimerycolor,
                                  context: context, 
                                  builder: (context) {

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // start costumer info
                                        SizedBox(
                                          height: height / 30,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width / 20,
                                            ),
                                            Text(
                                              "Informasi Pelanggan",
                                              style: TextStyle(
                                                color: notifire.getdarkscolor,
                                                fontFamily: 'Gilroy Bold',
                                                fontSize: height / 50,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height / 60,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Nomor Tujuan",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                _ctrDestination.text,
                                                style: TextStyle(
                                                  color: notifire.getdarkscolor,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 80,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Produk",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                "Pulsa ${Helpers.currencyFormatter(listDetail[index]["name_unique"].toDouble(), symbol: "")}",
                                                style: TextStyle(
                                                  color: notifire.getdarkscolor,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // end costumer info

                                        // start payment detail
                                        SizedBox(
                                          height: height / 60,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width / 20,
                                            ),
                                            Text(
                                              "Detail Pembayaran",
                                              style: TextStyle(
                                                color: notifire.getdarkscolor,
                                                fontFamily: 'Gilroy Bold',
                                                fontSize: height / 50,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height / 60,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Harga",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                Helpers.currencyFormatter(listDetail[index]["product_price_fixed"].toDouble()),
                                                style: TextStyle(
                                                  color:
                                                      notifire.getdarkscolor,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 80,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Admin",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                "Rp500",
                                                style: TextStyle(
                                                  color:
                                                      notifire.getdarkscolor,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: width / 20,
                                              horizontal: width / 20),
                                          child: const DottedLine(
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.center,
                                            lineLength: double.infinity,
                                            lineThickness: 1.0,
                                            dashLength: 4.0,
                                            dashColor: Colors.grey,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Total Bayar",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                Helpers.currencyFormatter( (listDetail[index]["product_price_fixed"]  + 500).toDouble() ),
                                                style: TextStyle(
                                                  color:
                                                      notifire.getdarkscolor,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // end payment detail

                                        // start balance info
                                        SizedBox(
                                          height: height / 30,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width / 20,
                                            ),
                                            Text(
                                              "Informasi Saldo",
                                              style: TextStyle(
                                                color: notifire.getdarkscolor,
                                                fontFamily: 'Gilroy Bold',
                                                fontSize: height / 50,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height / 60,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Paylater",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                Helpers.currencyFormatter(SharedPrefs().limitsAvailable, decimalDigits: 0),
                                                style: TextStyle(
                                                  color:
                                                      notifire.getdarkscolor,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 80,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Deposit",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                  color:
                                                      notifire.getdarkscolor,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // end costumer info

                                        // start action button
                                        SizedBox(
                                          height: height / 30,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 20),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: GestureDetector(
                                                onTap: () {
                                                  // Navigator.pop(context);
                                                },
                                                child: Custombutton.button2(
                                                    notifire.gettabwhitecolor,
                                                    "Ubah",
                                                    notifire.getdarkscolor),
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.symmetric(horizontal: width / 50)),
                                              Expanded(
                                                flex: 1,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    fetchDataAndNavigate(context, listDetail[index]);
                                                  },
                                                  child: Custombutton.button2(
                                                      notifire.getbluecolor,
                                                      "Konfirmasi",
                                                      Colors.white),
                                                ),
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 20,
                                        ),
                                        // end action button
                                      ],
                                    );
                                  }
                                );
                              },
                              child:  Container(
                                // width: double.infinity,
                                decoration: BoxDecoration(
                                  color: notifire.gettabwhitecolor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 2,
                                            child: Text("Pulsa")
                                          ),
                                          Expanded(flex: 2, child: Text(
                                            Helpers.currencyFormatter(listDetail[index]["name_unique"].toDouble(), symbol: ""),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: height / 60,
                                            fontFamily: 'Gilroy Bold'),
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 2,
                                            child: Text("Harga")
                                          ),
                                          Expanded(flex: 2, child: Text(
                                            Helpers.currencyFormatter(listDetail[index]["product_price_fixed"].toDouble()),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: height / 60,
                                            fontFamily: 'Gilroy Bold'),
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            );
                          });
                    }),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Accordion(
                        disableScrolling: true,
                        flipRightIconIfOpen: true,
                        contentVerticalPadding: 0,
                        scrollIntoViewOfItems: ScrollIntoViewOfItems.none,
                        contentBorderColor: Colors.transparent,
                        maxOpenSections: 1,
                        headerBackgroundColorOpened: Colors.black54,
                        headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                        children: [
                          for (var item in list) ...[
                            AccordionSection(
                              flipRightIconIfOpen: true,
                              headerBackgroundColor: notifire.gettabwhitecolor,
                              contentBackgroundColor: notifire.gettabwhitecolor,
                              header: Text(
                                item["name"],
                                style: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              contentHorizontalPadding: 20,
                              contentBorderWidth: 1,
                              content: Builder(builder: (context) {
                                List<dynamic> listDetail = item["child"];
                                // for (var iChild in item)
                                return Container(
                                  // height: height / 3,
                                  // height: double.infinity,
                                  color: Colors.transparent,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: listDetail.length,
                                      itemBuilder: (context, index) =>
                                          Column(children: [
                                            Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                              listDetail[index]
                                                                  ["name"])),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                              Helpers.currencyFormatter(
                                                                  listDetail[index]
                                                                          [
                                                                          "product_price_fixed"]
                                                                      .toDouble()),
                                                              textAlign:
                                                                  TextAlign
                                                                      .end)),
                                                    ],
                                                  ),
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(),
                                              child: Divider(
                                                color: notifire.getdarkgreycolor
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ])),
                                );
                              }),
                            )
                          ]
                        ]),
                  ],
                );
              }
            } else {
              return const Center(child: Text('Loading...'));
            }
          } on DioException catch (e) {
            if (e.response != null) {
              print(e.response?.data);
              print(e.response?.headers);
              print(e.response?.requestOptions);
            } else {
              // Something happened in setting up or sending the request that triggered an Error
              print(e.requestOptions);
              print(e.message);
            }
            return const Center(child: Text('Upst...'));
          }
        });
  }

  Future<Map<String, dynamic>> _generateFormData(dynamic productSelected) async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> userData = json.decode(SharedPrefs().userData);
    Map<String,dynamic> customerMeta = {
      "user_id": userData["id"],
      "code":  userData["code"],
      "name":  userData["name"],
      "first_name":  userData["first_name"],
      "last_name":  userData["last_name"],
      "phone":  userData["phone"],
      "email":  userData["email"]
    };

    Map<String, dynamic> transactionData = {
      "payment_method": "paylater",
      "destination": _txtDestination,
      "product_meta": productSelected,
      "customer_meta": customerMeta,
    };

    return transactionData;
  }

  Future<void> fetchDataAndNavigate(BuildContext context, dynamic productSelected) async {

    Map<String, dynamic> formData = await _generateFormData(productSelected);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmPin(formData: formData),
      ),
    );

  }
}
