import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/helper_data_json.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colornotifire.dart';

class HistoryPpob extends StatefulWidget {
  const HistoryPpob({Key? key}) : super(key: key);

  @override
  State<HistoryPpob> createState() => _HistoryPpobState();
}

class _HistoryPpobState extends State<HistoryPpob> {
  late ColorNotifire notifire;
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _data = [];
  bool _isLoading = false;
  int _page = 1;
  final int _perPage = 10;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  List iconname = [
    Icons.arrow_circle_up,
    Icons.arrow_circle_down,
    Icons.arrow_circle_down,
    Icons.arrow_circle_up,
    Icons.arrow_circle_down,
    Icons.arrow_circle_up,
  ];
  List colorname = [
    Colors.red,
    const Color(0xff6C56F9),
    const Color(0xff6C56F9),
    Colors.red,
    const Color(0xff6C56F9),
    Colors.red
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 50,
            ),
            Row(
              children: [
                // Text(
                //   CustomStrings.showinghistory,
                //   style: TextStyle(
                //       color: notifire.getdarkscolor,
                //       fontFamily: 'Gilroy Bold',
                //       fontSize: height / 50),
                // ),
                const Spacer(),
                Icon(
                  Icons.cloud_download_rounded,
                  color: notifire.getbluecolor,
                ),
                SizedBox(
                  width: width / 90,
                ),
                Text(
                  CustomStrings.download,
                  style: TextStyle(
                      color: notifire.getbluecolor,
                      fontFamily: 'Gilroy Bold',
                      fontSize: height / 50),
                ),
              ],
            ),
            SizedBox(
              height: height / 50,
            ),

            Container(
              height: height / 1.29,
              width: width,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _data.length + (_isLoading ? 1 : 0),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  
                  if (index < _data.length) {
                      return Column(
                          children: [
                            Padding(
                          padding: EdgeInsets.only(bottom: height / 60),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: notifire.gettabwhitecolor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20, vertical: height / 80),
                              child: Row(
                                children: [
                                  // Container(
                                  //   height: height / 16,
                                  //   width: width / 9,
                                  //   decoration: const BoxDecoration(
                                  //     color: Colors.transparent,
                                  //     shape: BoxShape.circle,
                                  //   ),
                                  //   child: Image.asset(
                                  //     img[index],
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: width / 50,
                                  // ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        HelpersDataJson.product(
                                            _data[index]["product_meta"],
                                            "product_name"),
                                        style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: height / 50,
                                            fontFamily: 'Gilroy Bold'),
                                      ),
                                      SizedBox(
                                        height: height / 150,
                                      ),
                                      Text(
                                        Helpers.dateTimeToFormat(
                                            _data[index]["created_at"],
                                            format: "dd MMM yy | hh:mm:ss"),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: height / 60,
                                            fontFamily: 'Gilroy Bold'),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        Helpers.currencyFormatter(_data[index]
                                                ["product_price_fixed"]
                                            .toDouble()),
                                        style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: height / 50,
                                            fontFamily: 'Gilroy Bold'),
                                      ),
                                      SizedBox(
                                        height: height / 150,
                                      ),
                                      statusTransaction(_data[index]['status_text'])
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                        child: Text('Please wait its loading...'));
                  }
                },
              ),
            ),

            SizedBox(
              height: height / 10,
            ),
           
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    try {
      if (_isLoading) return;
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> queries = {
        "page": _page,
        "per_page": _perPage
      };

      final client =
          ApiClient(Dio(BaseOptions(contentType: "application/json")));
      final dynamic get = await client.getHistoryTransaction(
          'Bearer ${SharedPrefs().token}',
          queries: queries);
    
      List<dynamic> newData = get["data"];
      print(newData);
      setState(() {
      // print(newData);
        _data.addAll(newData);
        _page++;
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response?.data);
        // print(e.response?.headers);
        // print(e.response?.requestOptions);
        bool status = e.response?.data["status"];
        if (status) {
          // return Center(child: Text('Upst...'));
          // return e.response;
        }
      } else {
        // print(e.requestOptions);
        // print(e.message);
      }
      rethrow;
    }
  }

  Widget statusTransaction(String statusText){
    List<String> words = statusText.split('! ');
    Color statusColor = notifire.getdarkscolor;
    if (words[0] == 'Proses sukses') {
        statusColor = const Color(0xff6C56F9);
    } else if(words[0] == 'Proses gagal') {
        statusColor = Colors.red;
    }
    return Text(
      words[0],
      style: TextStyle(
          color: statusColor,
          fontSize: height / 60,
          fontFamily: 'Gilroy Bold'),
    );
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }
}
