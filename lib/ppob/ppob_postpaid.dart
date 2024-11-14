import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/product_provider.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:kumpulpay/utils/media.dart';

class PpobPostpaid extends StatefulWidget {
  static String routeName = '/ppob/postpaid/product/index';
  final dynamic categoryData;
  final String? category;
  final String? type;
  const PpobPostpaid({Key? key, this.type, this.category, this.categoryData})
      : super(key: key);

  @override
  State<PpobPostpaid> createState() => _PpobPostpaidState();
}

class _PpobPostpaidState extends State<PpobPostpaid> {
  late ColorNotifire notifire;

  PpobPostpaid? args;
  final _formKey = GlobalKey<FormBuilderState>();
  dynamic _categoryData;
  String? _type;
  String? _category;
  String? _filterCategory;
  String? title;
  // List<dynamic>? providerList;
  dynamic selectedProvider;
  String selectedProviderName = 'Pilih Provider';

  // void _navigateToProvider(BuildContext context,
  //     {final List<dynamic>? providerList}) async {

  //   final result = await Navigator.pushNamed(
  //     context,
  //     ProductProvider.routeName,
  //     arguments: ProductProvider(
  //         providerList: providerList ?? [], // Gunakan default jika null
  //     ),
  //   );

  //   if (result != null) {
  //     setState(() {
  //       selectedProvider = result; // Perbarui selectedProvider
  //       selectedProviderName = selectedProvider['name'];
  //     });
  //     print("_navigateToProvider ${jsonEncode(result)}");
  //   }
  // }
  
  @override
  void initState() {
    super.initState();
    notifire = Provider.of<ColorNotifire>(context, listen: false);
    getdarkmodepreviousstate();
   
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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    args = ModalRoute.of(context)!.settings.arguments as PpobPostpaid?;
    _categoryData = args!.categoryData;
    _type = args!.type;
    _category = args!.categoryData['id'];
    print('_typeX ${_type}');

    _filterCategory = '${_type}_${_category}';

    title = args!.categoryData['short_name'];
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
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: textfeildC("input_nomor", "",
                  hintText: "Masukkan nomor...",
                  // enabled: _enabledInput,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  // maxLength: 15,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(9),
                  ]), onSubmitted: (value) {
                    if (_formKey.currentState?.validate() ?? false) {
                      final formValue =
                          _formKey.currentState?.fields['input_nomor']?.value;
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
                        return _bottomSheetContent(context);
                      });
                    } else {
                      print('Form tidak valid!');
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
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Pilih Provider",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: notifire.getdarkscolor,
                                fontSize: height / 50,
                                fontFamily: 'Gilroy Bold'),
                          ),
                        )),
                    SizedBox(
                      height: height / 70,
                    ),
                    _buildBody(context),
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

  FutureBuilder<dynamic> _buildBody(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    final Map<String, dynamic> queries = {"type": _type, "category": _category};
    print('queriesX ${queries}');

    return FutureBuilder<dynamic>(
      future:
          client.getProduct('Bearer ${SharedPrefs().token}', queries: queries),
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var rawList = snapshot.data["data"] as List<dynamic>;
              List<Map<String, dynamic>> list = rawList
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList();
              
              var providerList = groupDataByTypeCategoryProviderArray(list);
             
              return _buildView(providerList);
              
            } else {
              return const Center(child: Text('Data tidak ditemukan'));
            }
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
      },
    );
  }

  Widget _buildView(List<dynamic> items) {
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 15),
          child: GestureDetector(
            onTap: () {
              // _navigateToProvider(context, providerList: items);
             
            },
            child: Container(
              height: height / 15,
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
                    SizedBox(
                      width: width / 30,
                    ),
                    Text(
                      selectedProviderName,
                      style: TextStyle(
                        // fontFamily: "Gilroy Bold",
                        color: notifire.getdarkgreycolor,
                        // fontSize: height / 50
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios,
                        color: notifire.getdarkgreycolor, size: height / 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menangani session yang habis
  // Future<void> _handleSessionExpired(BuildContext context) async {
  //   // Contoh mekanisme refresh token
  //   try {
  //     final newToken = await client.refreshToken();
  //     SharedPrefs().token = newToken; // Simpan token baru
  //     setState(() {}); // Refresh UI
  //   } catch (e) {
  //     // Gagal refresh, arahkan ke login
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }

  Widget _bottomSheetContent(
      BuildContext ctxBsc) {
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
                "aasasas",
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
                "xx",
                // Helpers.currencyFormatter(
                //     double.parse(listDetail[index]["name_unique"]),
                //     symbol: ""),
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
                  "cc",
                  // listDetail[index]["name"],
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
                "mm",
                // Helpers.currencyFormatter(
                //     listDetail[index]["price_fixed"].toDouble()),
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
                "vv",
                // Helpers.currencyFormatter(
                //     (listDetail[index]["price_fixed"] + 500).toDouble()),
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
                    // fetchDataAndNavigate(context, listDetail[index]);
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
      String providerName =
          entry.value.isNotEmpty ? entry.value[0]["provider_name"] : "";
      String provider =
          entry.value.isNotEmpty ? entry.value[0]["provider"] : "";

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
}
