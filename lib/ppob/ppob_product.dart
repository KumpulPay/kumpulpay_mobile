import 'dart:convert';
import 'dart:developer';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/phone_provider.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/ppob_product_detail.dart';
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

class PpobProduct extends StatefulWidget {
  static String routeName = '/ppob/product/index';
  final dynamic categoryData;
  final String? category;
  final String? type;
  const PpobProduct({Key? key, this.type, this.category, this.categoryData}) : super(key: key);
  
  @override
  State<PpobProduct> createState() => _PpobProductState();

}

class _PpobProductState extends State<PpobProduct>
    with SingleTickerProviderStateMixin, ChangeNotifier {

  PpobProduct? args;    
  late ColorNotifire notifire;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> phoneProvider = {};
  dynamic _categoryData;
  String? _type;
  String? _category;
  String? _filterCategory; 
  String? title;

  String _txtDestination = "";
  String _txtProvider = "";
  String _txtLabelPriceList = "";

  bool _enabledInput = true;

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
    // _categoryData = widget.categoryData;
  }


  void handleFormSubmission({destination}) {
    Navigator.pushNamed(
      context, PpobProductDetail.routeName,
      arguments: PpobProductDetail(type: _type,category: _category, categoryData: _categoryData, txtDestination: destination)
    );
  }

  void listActionGo(dynamic value) {
    setState(() {
      // print('valueX ${value}');
      Navigator.pushNamed(
        context, PpobProductDetail.routeName,
        arguments: PpobProductDetail(type: _type,category: _category, categoryData: _categoryData, providerData: value, txtDestination: _txtProvider)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    args = ModalRoute.of(context)!.settings.arguments as PpobProduct?;
    _categoryData = args!.categoryData;
    _type = args!.type;
    _category = args!.categoryData['id'];
    _filterCategory = '${_type}_${_category}';

    title = args!.categoryData['short_name'];

    if (_filterCategory == 'prepaid_e_money') {
        _enabledInput = false;
    }
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
            preferredSize:
                const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  FormBuilder(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: textfeildC(
                        "input_nomor",
                        "",
                        hintText: "Masukkan nomor...",
                        enabled: _enabledInput,
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
                              if (_filterCategory == 'prepaid_pln_prepaid') {
                                _txtDestination = value;
                              } else {
                                handleFormSubmission(destination: value);
                              }
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
                      SizedBox(
                        height: height / 50,
                      ),
                      _buildList(context),
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
      prefixIcon,
      suffixIconInteractive,
      enabled,
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
                enabled: enabled,
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
    final Map<String, dynamic> queries = {
      "type": _type,
      "category": _category
    };
    // print('queriesX: ${queries}');
    return FutureBuilder<dynamic>(
        future: client.getProduct('Bearer ${SharedPrefs().token}',
            queries: queries),
        builder: (context, snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.done) {
              // print('dataX: ${snapshot.data['data']}');
              var rawList = snapshot.data["data"] as List<dynamic>;
              List<Map<String, dynamic>> list = rawList.map((item) => Map<String, dynamic>.from(item)).toList();
            
              if (_filterCategory == 'prepaid_pulsa' 
              || _filterCategory == 'prepaid_paket_data'
              || _filterCategory == 'prepaid_paket_sms'
              || _filterCategory == 'prepaid_paket_telepon'
              || _filterCategory == 'prepaid_e_money'
              ) {
                var groupedData = groupDataByTypeCategoryProviderArray(list);
               
                  _txtLabelPriceList = "Provider";
                  return _buildListAction(groupedData);
                  // return _buildItemAccordion(groupedData);
              } else if (_filterCategory  == 'prepaid_pln_prepaid'){
                return Container(
                  color: Colors.transparent,
                  width: width,
                  child: Builder(builder: (context) {
                    return _buildItemGridView(rawList);
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
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    if (_txtDestination.isNotEmpty) {
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
                              return _bottomSheetContent(
                                context,listDetail, index);
                          });
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
                              double.tryParse(listDetail[index]["name_unique"] ?? '0') ?? 0.0, symbol: ""),
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

  Widget _buildItemAccordion(List<Map<String, dynamic>> group1) {
  
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Text(
            "Daftar Harga $_txtLabelPriceList",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontSize: height / 50,
                fontFamily: 'Gilroy Bold'),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 40),
            child: Accordion(
                paddingListTop: height / 80,
                leftIcon: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                        "images/logo_app/playstore.png",
                        height: height / 25)),
                rightIcon: Transform.rotate(
                    angle: 45 * 3.14159 / 90,
                    child: Icon(Icons.arrow_forward_ios,
                        color: notifire.getdarkscolor, size: height / 50)),
                disableScrolling: true,
                flipRightIconIfOpen: true,
                contentVerticalPadding: 0,
                scrollIntoViewOfItems: ScrollIntoViewOfItems.none,
                contentBorderColor: Colors.transparent,
                maxOpenSections: 1,
                headerBackgroundColorOpened: Colors.black54,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                children: [
                  for (var item in group1) ...[
                    AccordionSection(
                        headerBackgroundColor: notifire.gettabwhitecolor,
                        contentBackgroundColor: notifire.gettabwhitecolor,
                        header: Text(
                          item["name"],
                          style: TextStyle(
                              fontFamily: "Gilroy Bold",
                              color: notifire.getdarkscolor,
                              fontSize: height / 55),
                        ),
                        contentHorizontalPadding: 20,
                        contentBorderWidth: 1,
                        content: Builder(builder: (context) {
                          List<dynamic> group2 = item["child"];
                        
                          if (_filterCategory == 'prepaid_pulsa' 
                          || _filterCategory == 'prepaid_paket_data'
                          || _filterCategory == 'prepaid_paket_sms'
                          || _filterCategory == 'prepaid_paket_telepon'
                              ) {
                            return _buildItemAccordionSub(group2);
                          }
                         
                          return const Text('Upst...');
                        }))
                  ]
                ]))
      ],
    );
  }

  Widget _buildItemAccordionSub(List<dynamic> group2) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Masukkan nomor terlebih dulu!")));
      },
      child: Container(
          // height: height / 3,
          // height: double.infinity,
          color: Colors.transparent,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: group2.length,
              itemBuilder: (context, index) {
                // print(group2[index]["price_fixed"]);
                double productPriceFixed =
                    group2[index]["price_fixed"].toDouble();
                return Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(group2[index]["name"],
                                  style: TextStyle(
                                      fontFamily: "Gilroy Medium",
                                      color: notifire.getdarkscolor,
                                      fontSize: height / 65))),
                          Expanded(
                              flex: 1,
                              child: Text(
                                Helpers.currencyFormatter(productPriceFixed),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontFamily: "Gilroy Bold",
                                    color: notifire.getdarkscolor,
                                    fontSize: height / 60),
                              )),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: Divider(
                      color: notifire.getdarkgreycolor.withOpacity(0.1),
                    ),
                  ),
                ]);
              })),
    );
  }

  Widget _buildItemAccordionData(List<dynamic> group1) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Text(
            "Daftar Harga $_txtLabelPriceList",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontSize: height / 50,
                fontFamily: 'Gilroy Bold'),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 40),
            child: Accordion(
                rightIcon: Transform.rotate(
                    angle: 45 * 3.14159 / 90,
                    child: Icon(Icons.arrow_forward_ios,
                        color: notifire.getdarkscolor, size: height / 50)),
                disableScrolling: true,
                flipRightIconIfOpen: true,
                contentVerticalPadding: 0,
                scrollIntoViewOfItems: ScrollIntoViewOfItems.none,
                maxOpenSections: 1,
                headerBackgroundColor: notifire.getdarkwhitecolor,
                // headerBackgroundColorOpened: Colors.blue,
                contentBorderWidth: 1,
                contentBorderRadius: 20,
                contentBorderColor: notifire.getdarkgreycolor.withOpacity(0.1),
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
                                            // _toggle();
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
                                                builder: (context) {
                                                  return _bottomSheetContent(context,
                                                      group2, index);
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
                                                  Text(
                                                      group2[index]["provider"],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Gilroy Bold",
                                                          color: notifire
                                                              .getdarkscolor,
                                                          fontSize:
                                                              height / 50)),
                                                  SizedBox(height: height / 90),
                                                  Text(group2[index]["name"],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Gilroy Medium",
                                                          color: notifire
                                                              .getdarkgreycolor
                                                              .withOpacity(0.6),
                                                          fontSize:
                                                              height / 65)),
                                                  SizedBox(height: height / 50),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          Helpers.currencyFormatter(
                                                              group2[index]
                                                                      ["price"]
                                                                  .toDouble()),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Gilroy Bold",
                                                              color: notifire
                                                                  .getdarkscolor,
                                                              fontSize:
                                                                  height / 50)),
                                                      const Spacer(),
                                                      const Text(
                                                        "Detail",
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(),
                                      child: Divider(
                                        color: notifire.getdarkgreycolor
                                            .withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }))
                  ]
                ]))
      ],
    );
  }

  Widget _buildListAction(List<dynamic> items) {
    // print('itemsX: ${items.length}');
    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: width / 20),
        //   child: Text(
        //     "Pilih $_txtLabelPriceList",
        //     textAlign: TextAlign.start,
        //     style: TextStyle(
        //         color: notifire.getdarkscolor,
        //         fontSize: height / 50,
        //         fontFamily: 'Gilroy Bold'),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Container(
            color: Colors.transparent,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                // print('itemXX ${items[index]}');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: GestureDetector(
                    onTap: () {
                      listActionGo(items[index]);
                    },
                    child: Container(
                      // height: height / 9,
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
                        padding: EdgeInsets.symmetric(horizontal: width / 20),
                        child: Row(
                          children: [
                            // start icon
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
                                  "images/logo_app/disabled_kumpulpay_logo.png",
                                  height: height / 20,
                                ),
                              ),
                            ),
                            // end icon
                            SizedBox(
                              width: width / 30,
                            ),
                            Text(
                              items[index]['name'],
                              style: TextStyle(
                                  fontFamily: "Gilroy Bold",
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 50),
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
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _bottomSheetContent(BuildContext ctxBsc, List<dynamic> listDetail, int index) {
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
                child: Text(
                  listDetail[index]["name"],
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: notifire.getdarkgreycolor,
                    fontFamily: 'Gilroy Medium',
                    fontSize: height / 60,
                  ),
                ),
              ),
              // Expanded(
              //     flex: 2,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         Text(
              //           listDetail[index]["provider"],
              //           textAlign: TextAlign.right,
              //           style: TextStyle(
              //             color: notifire.getdarkscolor,
              //             fontFamily: 'Gilroy Medium',
              //             fontSize: height / 60,
              //           ),
              //         ),
              //         Text(
              //           listDetail[index]["name"],
              //           textAlign: TextAlign.right,
              //           style: TextStyle(
              //             color: notifire.getdarkgreycolor,
              //             fontFamily: 'Gilroy Medium',
              //             fontSize: height / 60,
              //           ),
              //         ),
              //       ],
              //     ))
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
                    listDetail[index]["price_fixed"].toDouble()),
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
                Helpers.currencyFormatter(
                    (listDetail[index]["price_fixed"] + 500)
                        .toDouble()),
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
          height: height / 60,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
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
                Helpers.currencyFormatter(SharedPrefs().limitsAvailable,
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
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
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
                    fetchDataAndNavigate(context, listDetail[index]);
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
      "payment_method": "paylater",
      "destination": _txtDestination,
      "product_meta": productSelected,
      "customer_meta": customerMeta,
    };

    return transactionData;
  }

  Future<void> fetchDataAndNavigate(
      BuildContext context, dynamic productSelected) async {
    Map<String, dynamic> formData = await _generateFormData(productSelected);

    Navigator.pushNamed(
      context,
      ConfirmPin.routeName,
      arguments: ConfirmPin(formData: formData)
    );
  }

  List<Map<String, dynamic>> groupDataByTypeCategoryProviderArray(
      List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> tempGroupedData = {};

    for (var item in data) {
      // Buat "group key" berdasarkan type, category, dan provider
      String groupKey =
          '${item["type"]}_${item["category"]}_${item["provider"]}';

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
      // Ambil nama provider dari salah satu item di dalam grup
      String providerName = entry.value.isNotEmpty ? entry.value[0]["provider_name"] : "";
      String provider = entry.value.isNotEmpty ? entry.value[0]["provider"] : "";

      return {
        "group_key": entry.key,
        "provider": provider,
        "name": providerName,
        "child": entry.value,
      };
    }).toList();
    // print('groupedDataArrayX ${jsonEncode(groupedDataArray)}');
    return groupedDataArray;
  }
}
