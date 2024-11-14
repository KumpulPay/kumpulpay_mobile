import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/ppob_postpaid_single_provider.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends StatefulWidget {
  static String routeName = '/ppob/product/provider';
  final String? type, typeName, category, categoryName;
  const ProductProvider(
      {Key? key, this.type, this.typeName, this.category, this.categoryName})
      : super(key: key);

  @override
  State<ProductProvider> createState() => _ProductProviderState();
}

class _ProductProviderState extends State<ProductProvider> {
  late ColorNotifire notifire;

  ProductProvider? args;
  final _formKey = GlobalKey<FormBuilderState>();
  String? _type, _typeName;
  String? _category, _categoryName;
  List<dynamic> providerList = [];
  List<dynamic> filteredProviderList = []; // Daftar hasil filter
  late Future<dynamic> dataProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as ProductProvider?;

      _type = args!.type;
      _typeName = args!.typeName;
      _category = args!.category;
      _categoryName = args!.categoryName;
    });

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    notifire = Provider.of<ColorNotifire>(context, listen: false);

    final Map<String, dynamic> queries = {"type": _type, "category": _category};
    print('queriesX ${queries}');
    dataProvider = ApiClient(Dio(BaseOptions(contentType: "application/json")))
        .getProduct('Bearer ${SharedPrefs().token}', queries: queries);
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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          "Pilih Provider",
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
              child: textfeildC("cari_provider", "",
                  hintText: "Cari Provider...",
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
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height / 50,
                  ),
                  FutureBuilder(
                    future: dataProvider,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        var rawList = (snapshot.data
                            as Map<String, dynamic>)["data"] as List<dynamic>;

                        List<Map<String, dynamic>> list = rawList
                            .map((item) => Map<String, dynamic>.from(item))
                            .toList();

                        if (providerList.isEmpty) {
                          providerList =
                              groupDataByTypeCategoryProviderArray(list);
                          filteredProviderList = List.from(providerList);
                        }

                        return _buildListAction(filteredProviderList);
                      } else {
                        return const Center(child: Text("No data available"));
                      }
                    },
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
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
      String categoryName =
          entry.value.isNotEmpty ? entry.value[0]["category_name"] : "";

      return {
        "group_key": entry.key,
        "category_name": categoryName,
        "provider": provider,
        "provider_name": providerName,
        "child": entry.value,
      };
    }).toList();
    print('groupedDataArrayX ${jsonEncode(groupedDataArray)}');
    return groupedDataArray;
  }

  Widget _buildListAction(List<dynamic> items) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 15),
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
                      Navigator.pushNamed(
                          context, PpobPostpaidSingleProvider.routeName,
                          arguments: PpobPostpaidSingleProvider(
                            type: _type,
                            typeName: items[index]['category_name'],
                            categoryName: items[index]['provider_name'],
                            child: items[index]['child'],
                          ));
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
}
