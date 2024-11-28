

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/ppob_postpaid_single_provider.dart';
import 'package:kumpulpay/ppob/ppob_product.dart';
import 'package:kumpulpay/ppob/product_provider.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../utils/colornotifire.dart';
import '../utils/string.dart';

class Category extends StatefulWidget {
  static String routeName = '/category';
  final String? type;
  const Category({Key? key, this.type}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late ColorNotifire notifire;
  final TextEditingController _searchController = TextEditingController(); 
  late bool _loading = true;
  List<dynamic> categoryList = [];
  List<dynamic> filteredCategoryList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
        _onSearchChanged);

    dynamic fakeCategory = List.filled(7, {
      "id": "paket_data",
      "name": "Paket Data",
      "short_name": "Paket Data",
      "order": 1,
      "count_provider": 7
    });
    dynamic fakeCategoryType = {
      "id": "prepaid",
      "name": "Isi Ulang",
      "short_name": "Isi Ulang",
      "order": null,
      "child": fakeCategory
    };
    filteredCategoryList = List.filled(2, fakeCategoryType);
    _fetchCategoryData();
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
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          CustomStrings.allservices,
          style: TextStyle(
              fontFamily: "Gilroy Bold",
              color: notifire.getdarkscolor,
              fontSize: height / 40),
        ),
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: serarchtextField(
                Colors.black,
                notifire.getdarkgreycolor,
                notifire.getbluecolor,
                CustomStrings.search,
              ),
          )
          
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
                   
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget serarchtextField(
    textclr,
    hintclr,
    borderclr,
    hinttext,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 40),
      child: Container(
        color: Colors.transparent,
        height: height / 17,
        child: TextField(
          controller: _searchController,
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifire.getdarkwhitecolor,
            hintText: hinttext,
            prefixIcon: Icon(
              Icons.search,
              color: notifire.getdarkgreycolor,
            ),
            hintStyle: TextStyle(color: hintclr, fontSize: height / 60),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderclr),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredCategoryList = categoryList.where((category) {
        bool isMatch = category['name'].toLowerCase().contains(query);

        if (category['child'] != null) {
          for (var child in category['child']) {
            if (child['name'].toLowerCase().contains(query)) {
              return true;
            }
          }
        }

        return isMatch;
      }).toList();
    });
  }

  void _fetchCategoryData() async {
    final response = await ApiClient(AppConfig().configDio()).getProductCategory(
        authorization: 'Bearer ${SharedPrefs().token}');

    try {
      if (response.success) {
        setState(() {
          categoryList =
              response.data;
          filteredCategoryList = categoryList;
          _loading = false;
        });
      } else {
        setState(() {
          filteredCategoryList = [];
        });
      }
    } catch (e) {
      setState(() {
        filteredCategoryList = [];
      });
    }
  }

  Widget _buildList() {
    return Skeletonizer(
        enabled: _loading,
        child: Column(children: [
      for (var item in filteredCategoryList) ...[
        SizedBox(
          height: height / 50,
        ),
        Row(
          children: [
            SizedBox(
              width: width / 20,
            ),
            Text(
              item['short_name'],
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontSize: height / 50,
                  fontFamily: 'Gilroy Bold'),
            ),
          ],
        ),
        SizedBox(
          height: height / 40,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Container(
            color: Colors.transparent,
            // height: height / 3.5,
            width: width,
            child: Builder(builder: (context) {
              List<dynamic> child2 = item["child"];
              return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: height / 100),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: height / 10,
                    mainAxisExtent: height / 8,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: height / 50,
                    mainAxisSpacing: height / 100,
                  ),
                  itemCount: child2.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (item['id'] == 'prepaid') {
                                Navigator.pushNamed(
                                    context, PpobProduct.routeName,
                                    arguments: PpobProduct(
                                        type: item['id'],
                                        categoryData: child2[index]));
                              } else if (item['id'] == 'postpaid') {
                                if (child2[index]['count_provider'] > 1) {
                                  Navigator.pushNamed(
                                      context, ProductProvider.routeName,
                                      arguments: ProductProvider(
                                          type: item['id'],
                                          typeName: item['name'],
                                          category: child2[index]['id'],
                                          categoryName: child2[index]['name']));
                                } else {
                                  
                                  Navigator.pushNamed(context,
                                      PpobPostpaidSingleProvider.routeName,
                                      arguments: PpobPostpaidSingleProvider(
                                          type: item['id'],
                                          typeName: item['name'],
                                          category: child2[index]['id'],
                                          categoryName: child2[index]['name'],
                                          child: child2[index]['child']));
                                }
                              } else if (item['id'] == 'entertainment') {
                                Navigator.pushNamed(
                                    context, PpobProduct.routeName,
                                    arguments: PpobProduct(
                                        type: item['id'],
                                        categoryData: child2[index]));
                              }
                            },
                            child: Container(
                              height: height / 15,
                              width: width / 7,
                              decoration: BoxDecoration(
                                color: notifire.gettabwhitecolor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                      child: _loading
                                          ? Image.asset(
                                              "images/logo_app/disabled_kumpulpay_logo.png",
                                              height: height / 30,
                                            )
                                          : Helpers.setNetWorkImage(child2[index]['images']['image'], height_: height / 30)
                                     
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 120,
                          ),
                          Text(
                            child2[index]["short_name"],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: "Gilroy Medium",
                                color: notifire.getdarkscolor,
                                fontSize: height / 60),
                          ),
                        ],
                      ),
                    );
                  });
            }),
          ),
        ),
      ],
    ]));
  }
}
