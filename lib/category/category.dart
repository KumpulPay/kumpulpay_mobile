
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/ppob/ppob_product.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colornotifire.dart';
import '../utils/string.dart';

class Category extends StatefulWidget {
  final String? type;
  const Category({Key? key, this.type}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late ColorNotifire notifire;

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
        actions: [
          Icon(
            Icons.more_horiz_outlined,
            color: notifire.getdarkscolor,
            size: 35,
          ),
          const SizedBox(
            width: 10,
          )
        ],
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [

            _buildBody(context),

          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> _buildBody(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    return FutureBuilder<dynamic>(
      future: client.getProductCategory('Bearer ${SharedPrefs().token}'),
      builder: (context, snapshot) {
        try {
      
          if (snapshot.connectionState == ConnectionState.done) {
         
              List<dynamic> list = snapshot.data["data"];

              return Column(
              children: [
                for (var item in list)... [
                  SizedBox(
                    height: height / 50,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width / 20,
                      ),
                      Text(
                        item['name_mobile'],
                        style: TextStyle(
                            color: notifire.getdarkscolor,
                            fontSize: height / 50,
                            fontFamily: 'Gilroy Bold'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 60,
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
                            padding: EdgeInsets.only(bottom: height / 15),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: height / 10,
                              mainAxisExtent: height / 8,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: height / 50,
                              mainAxisSpacing: height / 40,
                            ),
                            itemCount: child2.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                         Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PpobProduct(
                                                type: child2[index]
                                                    ["category"]),
                                          ),
                                        );
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
                                          child: Image.asset(
                                            child2[index]["image_mobile"],
                                            height: height / 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 120,
                                    ),
                                    Text(
                                      child2[index]["name_mobile"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Gilroy Bold",
                                          color: notifire.getdarkscolor,
                                          fontSize: height / 60),
                                    ),
                                  ],
                                ),
                              );
                            });
                        }
                      ),
                      
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Divider(
                      color: notifire.getdarkgreycolor.withOpacity(0.4),
                    ),
                  ),
                ],  
              ],
            );

          } else {
              return const Text("Loading..",textAlign: TextAlign.center);
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
        }

        return const Text("Loading..", textAlign: TextAlign.center);
      },
    );
  }
}
