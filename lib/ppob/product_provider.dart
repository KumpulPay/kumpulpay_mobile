import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/ppob_postpaid_single_provider.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  late bool _loading = true;
  final _formKey = GlobalKey<FormBuilderState>();
  String? _type, _typeName;
  String? _category, _categoryName;
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as ProductProvider?;

      _type = args!.type;
      _typeName = args!.typeName;
      _category = args!.category;
      _categoryName = args!.categoryName;

      _fetchProviderData();
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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
         _categoryName ?? '',
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

                  _buildListAction(filteredProviderList),

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
                          String providerImage = items[index]['provider_images'] != null ? items[index]['provider_images']['image'] : '';
                          Navigator.pushNamed(
                              context, PpobPostpaidSingleProvider.routeName,
                              arguments: PpobPostpaidSingleProvider(
                                type: _type,
                                typeName: items[index]['category_name'],
                                category: _category,
                                categoryName: items[index]['provider_name'],
                                provider: items[index]['provider'],
                                providerImage: providerImage,
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
                                          : items[index]['provider_images'] !=
                                                  null
                                              ? Helpers.setNetWorkImage(
                                                  items[index]
                                                          ['provider_images']
                                                      ['image'],
                                                  height_: height / 30)
                                              : Image.asset(
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

  void _fetchProviderData() async {
    try {
      final Map<String, dynamic> queries = {"type": _type, "category": _category};
      final response = await ApiClient(AppConfig().configDio(context: context)).getProduct(authorization: 'Bearer ${SharedPrefs().token}', queries: queries);
      
      if (response.success) {
        setState(() {
          providerList = groupDataByTypeCategoryProviderArray(response.data);
          filteredProviderList = providerList;
          _loading = false;
        });
      } else {
        setState(() {
          filteredProviderList = [];
        });
      }
    } catch (e) {
      setState(() {
        filteredProviderList = [];
      });
    }
  }

  List<dynamic> groupDataByTypeCategoryProviderArray(List<dynamic> data) {
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
      dynamic providerImages =
          entry.value.isNotEmpty ? entry.value[0]["provider_images"] : "";    

      return {
        "group_key": entry.key,
        "category_name": categoryName,
        "provider": provider,
        "provider_name": providerName,
        "provider_images": providerImages,
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
            padding: EdgeInsets.symmetric(horizontal: width / 40),
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
