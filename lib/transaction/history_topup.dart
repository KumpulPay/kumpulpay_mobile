import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colornotifire.dart';
import 'package:string_capitalize/string_capitalize.dart';

class HistoryTopup extends StatefulWidget {
  const HistoryTopup({Key? key}) : super(key: key);

  @override
  State<HistoryTopup> createState() => _HistoryTopupState();
}

class _HistoryTopupState extends State<HistoryTopup> {
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
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // SizedBox(
            //   height: height / 50,
            // ),
            // Row(
            //   children: [
            //     Text(
            //       CustomStrings.showinghistory,
            //       style: TextStyle(
            //           color: notifire.getdarkscolor,
            //           fontFamily: 'Gilroy Bold',
            //           fontSize: height / 50),
            //     ),
            //     const Spacer(),
            //     Icon(
            //       Icons.cloud_download_rounded,
            //       color: notifire.getbluecolor,
            //     ),
            //     SizedBox(
            //       width: width / 90,
            //     ),
            //     Text(
            //       CustomStrings.download,
            //       style: TextStyle(
            //           color: notifire.getbluecolor,
            //           fontFamily: 'Gilroy Bold',
            //           fontSize: height / 50),
            //     ),
            //   ],
            // ),
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
                shrinkWrap: true,
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
                                  horizontal: width / 20,
                                  vertical: height / 80),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // fieldType(_data[index]['type']),
                                      fieldType("Deposit"),
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
                                            fontFamily: 'Gilroy Medium'),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        Helpers.currencyFormatter(
                                            _data[index]["amount"].toDouble()),
                                        style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: height / 50,
                                            fontFamily: 'Gilroy Bold'),
                                      ),
                                      SizedBox(
                                        height: height / 150,
                                      ),
                                      // statusTransaction(_data[index]['confirmed'])
                                      statusTransaction(_data[index])
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
              height: height / 30,
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

      Map<String, dynamic> queries = {"page": _page, "per_page": _perPage};

      final client =
          ApiClient(Dio(BaseOptions(contentType: "application/json")));
      final dynamic get = await client.getWalletDeposit(
          'Bearer ${SharedPrefs().token}',
          queries: queries);

      List<dynamic> newData = get["data"];
      print('newDataX ${newData}');
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

  Widget fieldType(String type) {
    return Text(
      type.capitalizeEach(),
      style: TextStyle(
          color: notifire.getdarkscolor,
          fontSize: height / 50,
          fontFamily: 'Gilroy Bold'),
    );
  }

  Widget statusTransaction(dynamic data) {
    String statusText = 'Proses';
    Color statusColor = notifire.getdarkscolor;
    if (data['approved']) {
      statusColor = const Color(0xff6C56F9);
      statusText = 'Sukses';
    } else if(data['rejected']){
      statusText = 'Ditolak';  
    } else if(data['canceled']){
      statusText = 'Batal';
    } else if (data['expired']) {
      statusText = 'Expire';
    }
    // if (confirmed) {
    //   statusColor = const Color(0xff6C56F9);
    //   statusText = 'Sukses';
    // }

    return Text(
      statusText,
      style: TextStyle(
          color: statusColor, fontSize: height / 60, fontFamily: 'Gilroy Bold'),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }
}
