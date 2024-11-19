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
import 'package:skeletonizer/skeletonizer.dart';
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
  late bool _loading = true;  
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
  List<dynamic> productList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as PpobProductDetail?;
      _type = args!.type;
      _category = args!.category;
      _categoryData = args!.categoryData;
      _providerData = args!.providerData;
      _filterCategory = '${_type}_${_category}';
      _txtDestination =
          _txtDestination.isEmpty ? args!.txtDestination : _txtDestination;
      // _txtDestination = args!.txtDestination;
      _txtProvider = args!.providerData['provider'] ?? '';
      if (_filterCategory != 'prepaid_e_money') {
        if (_txtDestination.isNotEmpty) {
          phoneProvider = PhoneProvider.getProvide(_txtDestination);
          _txtProvider = phoneProvider['provider'];
        }
      }

      title = '${_categoryData['name']} ${_txtProvider}';

      if (_filterCategory == 'prepaid_pulsa' ||
          _filterCategory == 'prepaid_e_money') {
        productList = List.filled(6, {
          "name_unique": "5000",
          "price_fixed": 0,
        });
      } else {
        productList = List.filled(6, {
          "name_unique": "BSMART",
          "price_fixed": 0,
        });
      }

      _fetchData();
    });    
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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Skeletonizer(
          enabled: _loading,
          child: Text(
              "${title?.capitalizeEach()}",
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontSize: height / 40,
                  fontFamily: 'Gilroy Bold'),
            )
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
              70), // Set preferred height of the TextField
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Skeletonizer(
              enabled: _loading,
              child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: textfeildC("input_nomor", "",
                      hintText: "Masukkan nomor...",
                      initialValue: _txtDestination,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(9),
                      ]), onSubmitted: (value) {
                        if (_formKey.currentState?.validate() ?? false) {
                          _txtDestination = value;
                        } else {
                          print('Form tidak valid!');
                        }
                      }, onChanged: (value) {
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
                )
            ),
          ),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(
                "images/background.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      
                      _buildList(),

                      SizedBox(
                        height: height / 50,
                      ),
                    ],
                  ),
                )
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
            padding: EdgeInsets.symmetric(horizontal: width / 40),
            child: FormBuilderTextFieldCustom.type1(
                notifire.getdarkscolor,
                Colors.grey, //hint color
                notifire.getPrimaryPurpleColor,
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

  void _fetchData() async {
    try {
      final Map<String, dynamic> queries = {
        "type": _type,
        "category": _category,
        "provider": _txtProvider
      };
      final response =
          await ApiClient(Dio(BaseOptions(contentType: "application/json")))
              .getProduct('Bearer ${SharedPrefs().token}', queries: queries);

      if (response['status']) {
        setState(() {
          if (_filterCategory == 'prepaid_pulsa' || _filterCategory == 'prepaid_e_money') {
            productList = response['data'];
            _loading = false;
          } else {
            productList =
                groupDataByTypeCategoryProviderPaketData(response['data']);
            _loading = false;
          }
        });
      } else {
        setState(() {
          productList = [];
        });
      }
    } catch (e) {
      setState(() {
        productList = [];
      });
    }
  }
  
  Widget _buildList(){
    if (_filterCategory == 'prepaid_pulsa' ||
        _filterCategory == 'prepaid_e_money') {
      return _buildItemGridView(productList);
    } else {
      return _buildItemAccordionData(productList);
    }
  }

  Widget _buildItemGridView(List<dynamic> listDetail) {
    return Skeletonizer(
      enabled: _loading,
      child: Container(
            color: Colors.transparent,
            width: width,
            child: Builder(builder: (context) {
              return Column(
                children: [
                   SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width / 20, vertical: height / 80),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columns
                                crossAxisSpacing:
                                    10.0, // Spacing between columns
                                mainAxisSpacing: 10.0, // Spacing between rows
                                childAspectRatio: 2.0),
                        itemCount: listDetail.length,
                        itemBuilder: (BuildContext ctxObs, index) {
                          double priceList = listDetail[index]["price"].toDouble() +
                              listDetail[index]["margin"].toDouble() -
                              listDetail[index]["discount"].toDouble();
                            
                          return GestureDetector(
                            onTap: () {
                              if (_txtDestination.isNotEmpty) {
                                _openBottomSheet(ctxObs, listDetail, index);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Masukkan nomor terlebih dulu!")));
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Helpers.currencyFormatter(
                                            double.parse(listDetail[index]
                                                ["name_unique"]),
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
                                          const Expanded(
                                              flex: 1, child: Text("Harga")),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                Helpers.currencyFormatter(priceList),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: notifire
                                                        .getPrimaryPurpleColor,
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
            }))
    );
  }

  Widget _buildItemAccordionData(List<dynamic> group1) {
    return Skeletonizer(
      enabled: _loading,
      child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 40),
                child: Accordion(
                    disableScrolling: true,
                    flipRightIconIfOpen: true,
                    contentVerticalPadding: 0,
                    contentBorderColor: Colors.transparent,
                    scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                    maxOpenSections: 1,
                    headerBackgroundColor: notifire.getdarkwhitecolor,
                    headerPadding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    children: [
                      for (var item in group1) ...[
                        AccordionSection(
                            header: Text(
                              item["name"],
                              style: TextStyle(
                                  fontFamily: "Gilroy Bold",
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 55),
                            ),
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
                                                if (_txtDestination.isNotEmpty) {
                                                  _openBottomSheet(context,group2, index);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Masukkan nomor terlebih dulu!")));
                                                }
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  // color: notifire.getdarkwhitecolor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width / 30,
                                                      vertical: height / 60),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          group2[index]["name"],
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Gilroy Medium",
                                                              color: notifire
                                                                  .getdarkgreycolor,
                                                              // .withOpacity(0.6),
                                                              fontSize:
                                                                  height / 50)),
                                                      SizedBox(
                                                          height: height / 50),
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
                                                                  color: notifire
                                                                      .getPrimaryPurpleColor,
                                                                  fontSize:
                                                                      height /
                                                                          50)),
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
        )
    );
  }

  Widget _bottomSheetContent(BuildContext ctxBsc, List<dynamic> listDetail, int index) {
    String productCode = listDetail[index]["name_unique"];
    if (_filterCategory == 'prepaid_pulsa' ||
          _filterCategory == 'prepaid_e_money') {
            productCode = Helpers.currencyFormatter(
                    double.parse(productCode),
                    symbol: "");
    }
    
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
                productCode,
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
                Helpers.currencyFormatter(
                    listDetail[index]["price"].toDouble() +
                        listDetail[index]["margin"].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),

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
                "-${Helpers.currencyFormatter(listDetail[index]["discount"].toDouble())}",
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

        // Start Admin
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Biaya Layanan",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                    listDetail[index]["admin_fee"].toDouble()),
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
                  child: Custombutton.button2(notifire.getbackcolor, "Ubah",
                      notifire.getPrimaryPurpleColor),
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
                      notifire.getPrimaryPurpleColor, "Konfirmasi", Colors.white),
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

  List<dynamic> groupDataByTypeCategoryProviderPaketData(
      List<dynamic> data) {
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