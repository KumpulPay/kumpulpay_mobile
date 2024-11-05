import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/product_provider.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
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

  void _navigateToProvider(BuildContext context,
      {final List<dynamic>? providerList}) async {

    final result = await Navigator.pushNamed(
      context,
      ProductProvider.routeName,
      arguments: ProductProvider(
          providerList: providerList ?? [], // Gunakan default jika null
      ),
    );

    if (result != null) {
      setState(() {
        selectedProvider = result; // Perbarui selectedProvider
      });
      print("_navigateToProvider ${jsonEncode(result)}");
    }
  }
  
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
                  if (_filterCategory == 'prepaid_pln_prepaid') {
                    // _txtDestination = value;
                  } else {
                    // handleFormSubmission(destination: value);
                  }
                } else {
                  print('Form tidak valid!');
                }
              }, onChanged: (value) {
                if (_formKey.currentState?.validate() ?? false) {
                  // _txtDestination = value;
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
    print('itemsX ${items}');
    print('selectedProvider ${selectedProvider}');
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 15),
          child: GestureDetector(
            onTap: () {
              _navigateToProvider(context, providerList: items);
             
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
                      "Pilih Provider",
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
