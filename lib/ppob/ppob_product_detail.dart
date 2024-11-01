import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/phone_provider.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/ppob_product.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/transaction/confirm_pin.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_capitalize/string_capitalize.dart';

class PpobProductDetail extends StatefulWidget {
  static String routeName = '/ppob/product/detail';
  final String? type;
  final String? category;
  final dynamic categoryData;
  final dynamic providerData;
  // final String? provider;
  final dynamic txtDestination;
  const PpobProductDetail({Key? key, this.type, this.category, this.categoryData, this.providerData, this.txtDestination}) : super(key: key);

  @override
  State<PpobProductDetail> createState() => _PpobProductDetailState();
}

class _PpobProductDetailState extends State<PpobProductDetail> {
  PpobProductDetail? args;
  late ColorNotifire notifire;
  final _formKey = GlobalKey<FormBuilderState>();
  
  dynamic _categoryData;
  dynamic _providerData;
  String? _type;
  String? _category;
  String? _filterCategory; 
  String _txtDestination = "";
  String? title;
  Map<String, dynamic> phoneProvider = {};
  String _txtProvider = "";

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

  void handleFormSubmission(String value) {
    // print('Text submitted: $value');
 
    // setState(() {
    //   _txtDestination = value;
    //   if (_type == 'pulsa' ||
    //       _type == 'data' ||
    //       _type == 'paket_sms' ||
    //       _type == 'paket_telepon') {
    //     phoneProvider = PhoneProvider.getProvide(value);
    //     print('phoneProvider: ${phoneProvider}');
    //   }
    // });
  }

  // void listActionGo(String value) {
  //   setState(() {
  //     _txtProvider = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as PpobProductDetail?;
    _type = args!.type;
    _category = args!.category;
    _categoryData = args!.categoryData;
    _providerData = args!.providerData;
    _filterCategory = '${_type}_${_category}';
    _txtDestination = _txtDestination.isEmpty ? args!.txtDestination : _txtDestination;
    // _txtDestination = args!.txtDestination;
    _txtProvider = args!.providerData['provider'] ?? '';
    if (_filterCategory != 'prepaid_e_money') {
        if (_txtDestination.isNotEmpty) {
          phoneProvider = PhoneProvider.getProvide(_txtDestination);
          _txtProvider = phoneProvider['provider'];
        }
    }
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    
    title = '${_categoryData['name']} ${_txtProvider}';
    print('_categoryDataX ${_categoryData}');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          "${title?.capitalizeEach()}",
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
              70), // Set preferred height of the TextField
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: //start input destination
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: textfeildC("input_nomor", "",
                      hintText: "Masukkan nomor...",
                      initialValue: _txtDestination,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      // maxLength: 15,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(9),
                      ]),
                      onSubmitted: (value) {
                          if (_formKey.currentState?.validate() ?? false) {   
                            final formValue = _formKey.currentState?.fields['input_nomor']?.value;                       
                            // handleFormSubmission(formValue);
                          } else {
                            print('Form tidak valid!');
                          }
                      },
                      onChanged: (value) {
                        if (_formKey.currentState?.validate() ?? false) {
                          _txtDestination = value;
                        }
                      },
                      suffixIconInteractive: GestureDetector(
                        onTap: () {
                          // _toggle();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height / 50, horizontal: height / 70),
                          child: Image.asset(
                            "images/ic_contact.png",
                            height: height / 50,
                          ),
                        ),
                      )),
                ),
            // end input destination
          ),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Column(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            )
          ],
        ),
      ),
    );
  }

  Widget textfeildC(name, labelText_,
      {hintText,
      labelText,
      initialValue,
      prefixIcon,
      suffixIconInteractive,
      keyboardType,
      textInputAction,
      suffixIcon,
      validator,
      onSubmitted,
      onChanged,
      maxLength}) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 20),
            child: FormBuilderTextFieldCustom.type1(
                notifire.getdarkscolor,
                Colors.grey, //hint color
                notifire.getbluecolor,
                notifire.getdarkwhitecolor,
                hintText: hintText,
                prefixIcon: prefixIcon,
                name: name,
                initialValue: initialValue,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                labelText: labelText,
                // suffixIcon: suffixIcon,
                suffixIconInteractive: suffixIconInteractive,
                maxLength: maxLength,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                validator: validator ?? FormBuilderValidators.required()))
      ],
    );
  }

  FutureBuilder<dynamic> _buildList(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    final Map<String, dynamic> queries = {"type": _type, "category": _category, "provider": _txtProvider};
    // print('queriesX: ${queries}');

    return FutureBuilder<dynamic>(
        future: client.getProduct('Bearer ${SharedPrefs().token}',
            queries: queries),
        builder: (context, snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.done) {
              var rawList = snapshot.data["data"] as List<dynamic>;
              List<Map<String, dynamic>> list = rawList.map((item) => Map<String, dynamic>.from(item)).toList();
              // print('listX: ${list}');
              
              if (_filterCategory == 'prepaid_pulsa') {
                return Container(
                  color: Colors.transparent,
                  width: width,
                  child: Builder(builder: (context) {
                    return _buildItemGridView(list);
                  }),
                );
              } else if (_filterCategory == 'prepaid_paket_data' 
              || _filterCategory == 'prepaid_paket_sms'
              || _filterCategory == 'prepaid_paket_telepon'
              ){
                var groupedData = groupDataByTypeCategoryProviderPaketData(list);
                // print('groupedDataX ${groupedData}');
                return _buildItemAccordionData(groupedData);
              } else if (_filterCategory == 'prepaid_e_money'){
                return Container(
                  color: Colors.transparent,
                  width: width,
                  child: Builder(builder: (context) {
                    return _buildItemGridView(list);
                  }),
                );
              }
              
            } else {
              return const Center(child: Text('Loading...'));
            }
          } on DioException catch (e) {
            if (e.response != null) {
              // print(e.response?.data);
              // print(e.response?.headers);
              // print(e.response?.requestOptions);
            } else {
              // print(e.requestOptions);
              // print(e.message);
            }
            return const Center(child: Text('Upst...'));
          }
          return const Center(child: Text('Upst...'));
        });
  }

  Widget _buildItemGridView(List<dynamic> listDetail) {
    // print('listDetail: ${listDetail}');
    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: width / 20),
        //   child: Text(
        //     "Daftar Harga $_txtLabelPriceList",
        //     textAlign: TextAlign.start,
        //     style: TextStyle(
        //         color: notifire.getdarkscolor,
        //         fontSize: height / 50,
        //         fontFamily: 'Gilroy Bold'),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 20, vertical: height / 80),
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                  childAspectRatio: 2.0),
              itemCount: listDetail.length,
              itemBuilder: (BuildContext ctxObs, index) {
                return GestureDetector(
                  onTap: () {
                    if (_txtDestination.isNotEmpty) {
                      _openBottomSheet(ctxObs, listDetail, index);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Masukkan nomor terlebih dulu!")));
                    }
                  },
                  child: Container(
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
                            Text(
                              Helpers.currencyFormatter(
                                  double.parse(listDetail[index]["name_unique"]),
                                  symbol: ""),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 30,
                                  fontFamily: 'Gilroy Light'),
                            ),
                            SizedBox(
                              height: height / 80,
                            ),
                            Row(
                              children: [
                                const Expanded(flex: 1, child: Text("Harga")),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      Helpers.currencyFormatter(
                                          listDetail[index]
                                                  ["price_fixed"]
                                              .toDouble()),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: notifire.getbluecolor,
                                          fontSize: height / 60,
                                          fontFamily: 'Gilroy Bold'),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      )),
                );
              }),
        )
      ],
    );
  }

  Widget _buildItemAccordionData(List<Map<String, dynamic>> group1) {
    // print('group1X ${group1}');
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 40),
            child: Accordion(
                // rightIcon: Transform.rotate(
                //     angle: 45 * 3.14159 / 90,
                //     child: Icon(Icons.arrow_forward_ios,
                //         color: notifire.getdarkscolor, size: height / 50)),
                disableScrolling: true,
                flipRightIconIfOpen: true,
                contentVerticalPadding: 0,
                contentBorderColor: Colors.transparent,
                scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                maxOpenSections: 1,
                headerBackgroundColor: notifire.getdarkwhitecolor,
                // headerBackgroundColorOpened: Colors.blue,
                // contentBorderWidth: 1,
                // contentBorderRadius: 20,
                // contentBorderColor: notifire.getdarkgreycolor.withOpacity(0.1),
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                children: [
                  for (var item in group1) ...[
                    AccordionSection(
                        // flipRightIconIfOpen: true,
                        header: Text(
                          item["name"],
                          style: TextStyle(
                              fontFamily: "Gilroy Bold",
                              color: notifire.getdarkscolor,
                              fontSize: height / 55),
                        ),
                        // contentBackgroundColor: Colors.transparent,
                        contentHorizontalPadding: 20,
                        content: Builder(builder: (context) {
                          List<dynamic> group2 = item["child"];

                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: group2.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: height / 100),
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    notifire.getprimerycolor,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return _bottomSheetContent(
                                                      context, group2, index);
                                                });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              // color: notifire.getdarkwhitecolor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width / 30,
                                                  vertical: height / 60),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Text(
                                                  //     group2[index]["provider"],
                                                  //     maxLines: 1,
                                                  //     overflow:
                                                  //         TextOverflow.ellipsis,
                                                  //     style: TextStyle(
                                                  //         fontFamily:
                                                  //             "Gilroy Bold",
                                                  //         color: notifire
                                                  //             .getdarkscolor,
                                                  //         fontSize:
                                                  //             height / 50)),
                                                  // SizedBox(height: height / 90),
                                                  Text(group2[index]["name"],
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Gilroy Medium",
                                                          color: notifire
                                                              .getdarkgreycolor,
                                                              // .withOpacity(0.6),
                                                          fontSize:
                                                              height / 50)),
                                                  SizedBox(height: height / 50),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Harga",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Gilroy Medium",
                                                          fontSize:
                                                                height / 50,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                          Helpers.currencyFormatter(
                                                              group2[index][
                                                                      "price_fixed"]
                                                                  .toDouble()),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Gilroy Bold",
                                                              color: notifire.getbluecolor,
                                                              fontSize:
                                                                  height / 50)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(),
                                    //   child: Divider(
                                    //     color: notifire.getdarkgreycolor
                                    //         .withOpacity(0.1),
                                    //   ),
                                    // ),
                                  ],
                                );
                              });
                        }))
                  ]
                ]))
      ],
    );
  }

  Widget _bottomSheetContent(BuildContext ctxBsc, List<dynamic> listDetail, int index) {
    // String? title = _category?.capitalizeEach();
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
              "Informasi Pembelian",
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
                _txtDestination,
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
                'Produk ${title?.capitalizeEach()}',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                    double.parse(listDetail[index]["name_unique"]),
                    symbol: ""),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // description
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Deskripsi',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Gilroy Medium',
                    fontSize: height / 60,
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        listDetail[index]["provider"],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: notifire.getdarkscolor,
                          fontFamily: 'Gilroy Medium',
                          fontSize: height / 60,
                        ),
                      ),
                      Text(
                        listDetail[index]["name"],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: notifire.getdarkgreycolor,
                          fontFamily: 'Gilroy Medium',
                          fontSize: height / 60,
                        ),
                      ),
                    ],
                  ))
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
          padding: EdgeInsets.symmetric(horizontal: width / 20),
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
                Helpers.currencyFormatter(listDetail[index]["price_fixed"].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),

        // Start Admin
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
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
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // End Admin

        // Start Discount
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Diskon",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                  double.tryParse(listDetail[index]["discount"] ?? '0') ?? 0.0),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // End Discount

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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
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
                Helpers.currencyFormatter(listDetail[index]["price_fixed"].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
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
        // SizedBox(
        //   height: height / 60,
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: width / 20),
        //   child: Row(
        //     children: [
        //       Text(
        //         "Paylater",
        //         style: TextStyle(
        //           color: Colors.grey,
        //           fontFamily: 'Gilroy Medium',
        //           fontSize: height / 60,
        //         ),
        //       ),
        //       const Spacer(),
        //       Text(
        //         Helpers.currencyFormatter(SharedPrefs().limitsAvailable,
        //             decimalDigits: 0),
        //         style: TextStyle(
        //           color: notifire.getdarkscolor,
        //           fontFamily: 'Gilroy Medium',
        //           fontSize: height / 60,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Saldo",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(SharedPrefs().balanceAvailable,
                    decimalDigits: 0),
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

        // start action button
        SizedBox(
          height: height / 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(ctxBsc);
                  },
                  child: Custombutton.button2(notifire.gettabwhitecolor, "Ubah",
                      notifire.getdarkscolor),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: width / 50)),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    fetchDataAndNavigate(ctxBsc, listDetail[index]);
                  },
                  child: Custombutton.button2(
                      notifire.getbluecolor, "Konfirmasi", Colors.white),
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

  void _openBottomSheet(BuildContext ctxObs, List<dynamic> listDetail, int index) {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: notifire.getprimerycolor,
        context: ctxObs,
        builder: (BuildContext ctxSbs) {
          return _bottomSheetContent(ctxSbs, listDetail, index);
        });
  }

  Future<void> fetchDataAndNavigate(
      BuildContext context, dynamic productSelected) async {
    Map<String, dynamic> formData = await _generateFormData(productSelected);

    Navigator.pushNamed(context, ConfirmPin.routeName,
        arguments: ConfirmPin(formData: formData));
  }

  Future<Map<String, dynamic>> _generateFormData(
      dynamic productSelected) async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> userData = json.decode(SharedPrefs().userData);
    Map<String, dynamic> customerMeta = {
      "user_id": userData["id"],
      "code": userData["code"],
      "name": userData["name"],
      "first_name": userData["first_name"],
      "last_name": userData["last_name"],
      "phone": userData["phone"],
      "email": userData["email"]
    };

    Map<String, dynamic> transactionData = {
      "payment_method": "balance",
      "destination": _txtDestination,
      "product_meta": productSelected,
      "customer_meta": customerMeta,
    };

    return transactionData;
  }

  List<Map<String, dynamic>> groupDataByTypeCategoryProviderPaketData(
      List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> tempGroupedData = {};

    for (var item in data) {
     
      var splitDescription = item["description"].split(" | "); 
      String groupKey =
          '${item["type"]}_${item["category"]}_${splitDescription[0].trim()}';

      // Jika group key belum ada di dalam tempGroupedData, tambahkan dengan list kosong
      if (!tempGroupedData.containsKey(groupKey)) {
        tempGroupedData[groupKey] = [];
      }

      // Tambahkan item ke list pada group key yang sesuai
      tempGroupedData[groupKey]!.add(item);
    }

    // Konversi tempGroupedData menjadi list sesuai dengan format yang diminta
    List<Map<String, dynamic>> groupedDataArray =
        tempGroupedData.entries.map((entry) {
      
      var splitDesc = entry.value.isNotEmpty ? entry.value[0]["description"].split(" | ") : ""; 
      var provider =entry.value[0]["provider"]; 
      // provider = RegExp.escape(provider) + ' Data';

      String providerName = splitDesc[0];
      String name = providerName
      .replaceAll(RegExp('${provider} Data', caseSensitive: false), '')
      .replaceAll(RegExp('Data ${provider}', caseSensitive: false), '')
      .replaceAll(RegExp('${provider} Paket', caseSensitive: false), '')
      .replaceAll(RegExp('${provider}', caseSensitive: false), '');
      
      // print('nameX ${provider}');
      return {
        "group_key": entry.key,
        "name": name.trim(),
        "child": entry.value,
      };
    }).toList();
    // print('groupedDataArrayX ${jsonEncode(groupedDataArray)}');
    return groupedDataArray;
  }
}