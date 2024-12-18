import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/ppob_product_detail.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/transaction/confirm_pin.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
  late bool _loading = true;    
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> phoneProvider = {};
  dynamic _categoryData;
  String? _type;
  String? _category;
  String? _filterCategory; 
  String? title;
  String _txtDestination = "";
  final String _txtProvider = "";
  List<dynamic> productList = List.filled(6, {
    "category": "pulsa_postpaid",
    "category_name": "Pulsa Pascabayar",
    "category_short_name": "Pulsa Pasca",
  });
  List<dynamic> providerList = [];
  List<dynamic> filteredProviderList = List.filled(8, {
    "group_key": "group_key",
    "category_name": "category_name",
    "provider": "provider",
    "provider_name": "provider_name",
    "provider_images": "images/logo_app/disabled_kumpulpay_logo.png",
    "child": [
      {
        "type": "postpaid",
        "type_name": "Bayar Tagihan",
        "type_short_name": "Bayar Tagihan",
        "category": "pulsa_postpaid",
        "category_name": "Pulsa Pascabayar",
        "category_short_name": "Pulsa Pasca",
      }
    ]
  });
  bool _isFilterProvider = true;
  Map<String, dynamic>? startsWithC;
  dynamic dataCheck;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as PpobProduct?;
      _categoryData = args!.categoryData;
      _type = args!.type;
      _category = args!.categoryData['id'];
      _filterCategory = "${_type}-${_category}";
      title = args!.categoryData['short_name'];

      if (_filterCategory == 'prepaid-pln_prepaid') {
        _isFilterProvider = false;
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

  void handleFormSubmission({destination}) {
    Navigator.pushNamed(
      context, PpobProductDetail.routeName,
      arguments: PpobProductDetail(type: _type,category: _category, categoryData: _categoryData, txtDestination: destination)
    );
  }

  void listActionGo(dynamic value) {
    setState(() {
      Navigator.pushNamed(
        context, PpobProductDetail.routeName,
        arguments: PpobProductDetail(type: _type,category: _category, categoryData: _categoryData, providerData: value, txtDestination: _txtProvider)
      );
    });
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
            preferredSize:
                const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Skeletonizer(
                enabled: _loading,
                child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: _isFilterProvider
                      ? inputSearchProvider()
                      : inputAccountNumber(),
                ),
              )
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
                      Skeletonizer(
                        enabled: _loading,
                        child: _isFilterProvider
                          ? _buildListAction(filteredProviderList)
                          : _buildItemGridView(productList)
                      ),
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

  Widget inputSearchProvider() {
    return textfeildC("input_nomor", "",
        hintText: "Cari Provider",
        textInputAction: TextInputAction.done, onChanged: (value) {
          _filterProviderList(value ?? '');
        },
        suffixIconInteractive: GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height / 50, horizontal: height / 70),
            child: Image.asset(
              "images/search.png",
              height: height / 50,
            ),
          ),
        ));
  }

  Widget inputAccountNumber() {
    return textfeildC("input_nomor", "",
        hintText: "Masukkan nomor...",
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(9),
        ]), onSubmitted: (value) {
      if (_formKey.currentState?.validate() ?? false) {
        final formValue = _formKey.currentState?.fields['input_nomor']?.value;
        if (_filterCategory == 'prepaid-pln_prepaid') {
          _txtDestination = value;
        } else {
          handleFormSubmission(destination: value);
        }
      } else {
        print('Form tidak valid!');
      }
    }, onChanged: (value) {
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
        ));
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
            padding: EdgeInsets.symmetric(horizontal: width / 40),
            child: FormBuilderTextFieldCustom.type1(
                notifire.getdarkscolor,
                Colors.grey, //hint color
                notifire.getPrimaryPurpleColor,
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

  void _filterProviderList(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProviderList = List.from(providerList);
      } else {
        filteredProviderList = List.from(providerList)
            .where((provider) => provider['provider_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _fetchData() async {
    try {
      final Map<String, dynamic> queries = {"type": _type, "category": _category};
      final response = await ApiClient(AppConfig().configDio(context: context)).getProduct(authorization: 'Bearer ${SharedPrefs().token}', queries: queries);
      
      if (response.success) {
        setState(() {
          if (_filterCategory != 'prepaid-pln_prepaid'){
            providerList = groupDataByTypeCategoryProviderArray(response.data);
            filteredProviderList = providerList;
           
          } else {
            List<dynamic> data = response.data;

            // Filter data where code starts with "C" (case-insensitive)
            startsWithC = data.firstWhere(
              (item) {
                String code = item['code'] ?? '';
                return code.toLowerCase().startsWith('c');
              },
              orElse: () => null,
            );
           
            // Filter data where code does not start with "C"
            List<dynamic> doesNotStartWithC = data.where((item) {
              String code = item['code'] ?? '';
              return !code.toLowerCase().startsWith('c');
            }).toList();

            productList = doesNotStartWithC;
          }
          _loading = false;
        });
      } else {
        setState(() {
          filteredProviderList = [];
          productList = [];
        });
      }
    } catch (e) {
      setState(() {
        filteredProviderList = [];
        productList = [];
      });
    }
  }

  Widget _buildItemGridView(List<dynamic> listDetail) {
    return Container(
        color: Colors.transparent,
        width: width,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width / 20, vertical: height / 80),
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columns
                            crossAxisSpacing: 10.0, // Spacing between columns
                            mainAxisSpacing: 10.0, // Spacing between rows
                            childAspectRatio: 2.0),
                    itemCount: listDetail.length,
                    itemBuilder: (BuildContext ctx, index) {
                      double priceList = listDetail[index]["price"].toDouble() +
                          listDetail[index]["margin"].toDouble() -
                          listDetail[index]["discount"].toDouble();
                      return GestureDetector(
                        onTap: () async {
                          if (_txtDestination.isNotEmpty) {
                            
                            await _checkBill(ctx, listDetail, index);
                           
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Masukkan nomor terlebih dulu!")));
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Helpers.currencyFormatter(
                                        double.tryParse(listDetail[index]
                                                    ["name_unique"] ??
                                                '0') ??
                                            0.0,
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
                                            Helpers.currencyFormatter(
                                                priceList),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: notifire.getPrimaryPurpleColor,
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
        }));
  }

  Widget _buildListAction(List<dynamic> items) {
    return Skeletonizer(
        enabled: _loading,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: Container(
                color: Colors.transparent,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
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
                            padding:
                                EdgeInsets.symmetric(horizontal: width / 40),
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
                                      child: _loading
                                          ? Image.asset(
                                              "images/logo_app/disabled_kumpulpay_logo.png", // Gambar fallback jika provider_images null atau kosong
                                              height: height / 30,
                                            )
                                          : items[index]['provider_images'] != null ? Helpers.setNetWorkImage(
                                              items[index]['provider_images']['image'], height_: height/30) : Image.asset(
                                                  "images/logo_app/disabled_kumpulpay_logo.png", // Gambar fallback jika provider_images null atau kosong
                                                  height: height / 30,
                                                )
                                  ),
                                ),
                                // end icon
                                SizedBox(
                                  width: width / 30,
                                ),
                                Text(
                                  items[index]['provider_name'],
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
        ));
  }

  Widget _bottomSheetContent(BuildContext ctxBsc, List<dynamic> listDetail, int index) {
    // saldo sebelum
    double currentBalance = dataCheck['user_detail']['balance'].toDouble();
    // saldo setelah
    double remainingBalance = currentBalance - listDetail[index]["price_fixed"].toDouble();
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
        // start customer name
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                'Nama Pelanggan',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
               dataCheck['bill_details']['customer_name'],
                style: TextStyle(
                  color: notifire.getdarkgreycolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // end customer name
        // start tarif daya
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                'Tarif/Daya',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                "${dataCheck['bill_details']['golongan']}/${dataCheck['bill_details']['daya']}",
                style: TextStyle(
                  color: notifire.getdarkgreycolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // end tarif daya
        // start description
        // SizedBox(
        //   height: height / 80,
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: width / 20),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Expanded(
        //         flex: 1,
        //         child: Text(
        //           'Deskripsi',
        //           style: TextStyle(
        //             color: Colors.grey,
        //             fontFamily: 'Gilroy Medium',
        //             fontSize: height / 60,
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         flex: 2,
        //         child: Text(
        //           listDetail[index]["name"],
        //           textAlign: TextAlign.right,
        //           style: TextStyle(
        //             color: notifire.getdarkgreycolor,
        //             fontFamily: 'Gilroy Medium',
        //             fontSize: height / 60,
        //           ),
        //         ),
        //       ),
        //       // Expanded(
        //       //     flex: 2,
        //       //     child: Column(
        //       //       crossAxisAlignment: CrossAxisAlignment.end,
        //       //       children: [
        //       //         Text(
        //       //           listDetail[index]["provider"],
        //       //           textAlign: TextAlign.right,
        //       //           style: TextStyle(
        //       //             color: notifire.getdarkscolor,
        //       //             fontFamily: 'Gilroy Medium',
        //       //             fontSize: height / 60,
        //       //           ),
        //       //         ),
        //       //         Text(
        //       //           listDetail[index]["name"],
        //       //           textAlign: TextAlign.right,
        //       //           style: TextStyle(
        //       //             color: notifire.getdarkgreycolor,
        //       //             fontFamily: 'Gilroy Medium',
        //       //             fontSize: height / 60,
        //       //           ),
        //       //         ),
        //       //       ],
        //       //     ))
        //     ],
        //   ),
        // ),
        // end description
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
        ),SizedBox(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Helpers.currencyFormatter(currentBalance),
                    style: TextStyle(
                      color: notifire.getdarkscolor,
                      fontFamily: 'Gilroy Medium',
                      fontSize: height / 60,
                    ),
                  ),
                  if (remainingBalance < 0)
                   Text(
                      "Kurang ${Helpers.currencyFormatter(remainingBalance)}",
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Gilroy Medium',
                        fontSize: height / 60,
                      ),
                    ), 
                ],
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
                      notifire.getdarkscolor),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: width / 50)),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if (remainingBalance < 0) {
                      Helpers.showMbsAlert(
                          context: context,
                          title: 'Gagal!',
                          subtitle:
                              'Saldo kamu saat ini ${Helpers.currencyFormatter(currentBalance)} tidak cukup untuk melakukan transaksi senilai ${Helpers.currencyFormatter(listDetail[index]['price_fixed'].toDouble())}',
                          typeAlert: 'info');
                    } else {
                      fetchDataAndNavigate(context, listDetail[index]);
                    }
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

  Future<Map<String, dynamic>> _generateFormData(
      dynamic productSelected) async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> orderDetail = {
      "destination": _txtDestination,
      "price": productSelected['price'],
      "margin": productSelected['margin'],
      "discount": productSelected['discount'],
      "admin_fee": productSelected['admin_fee'],
      "price_fixed": productSelected['price_fixed']
    };

    Map<String, dynamic> transactionData = {
      "transaction_type": "purchase",
      "payment_method": "deposit",
      "order_detail": orderDetail,
      "product_meta": productSelected,
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

  Future<dynamic> _checkBill(
      BuildContext ctxObs, List<dynamic> listDetail, int index) async {

    Loading.showLoadingDialog(context, _globalKey);    
    try {
      Map<String, dynamic> body = {
        "product_code": startsWithC!['code'],
        "destination": _txtDestination,
        "type_category_provider": startsWithC!['type_category_provider'],
      };

      final response = await ApiClient(AppConfig().configDio(context: context)).postCheckBill(
          authorization: 'Bearer ${SharedPrefs().token}', body: body);
      Navigator.pop(context);
      if (response.success) {
        dataCheck = response.data;
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
            builder: (context) {
              return _bottomSheetContent(context, listDetail, index);
            });
      } else {
        Helpers.showMbsAlert(context: context, title: 'Gagal!', subtitle: response.message, typeAlert: 'info');

      }
    } on DioException catch (e) {
      Fluttertoast.showToast(
        msg: e.response != null
            ? e.response?.data["message"] ?? "Terjadi kesalahan pada server."
            : "Koneksi gagal, periksa jaringan Anda.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      rethrow;
    }
  }

  List<dynamic> groupDataByTypeCategoryProviderArray(
      List<dynamic> data) {
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
      dynamic providerImages = entry.value.isNotEmpty ? entry.value[0]["provider_images"] : "";

      return {
        "group_key": entry.key,
        "provider": provider,
        "provider_name": providerName,
        "provider_images": providerImages,
        "child": entry.value,
      };
    }).toList();
    // print('groupedDataArrayX ${jsonEncode(groupedDataArray)}');
    return groupedDataArray;
  }
}
