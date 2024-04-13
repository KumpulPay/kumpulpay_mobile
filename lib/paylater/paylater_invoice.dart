import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/text_style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaylaterInvoice extends StatefulWidget {
  const PaylaterInvoice({Key? key}) : super(key: key);

  @override
  State<PaylaterInvoice> createState() => _PaylaterInvoiceState();
}

class _PaylaterInvoiceState extends State<PaylaterInvoice> {
  late ColorNotifire notifire;
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _data = [];
  bool _isLoading = false;
  int _page = 1;
  int _perPage = 10;

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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        title: Text(
          "Tagihan",
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            height: height * 0.8,
            width: width,
            color: Colors.transparent,
            child: Image.asset(
              "images/background.png",
              fit: BoxFit.cover,
            ),
          ),


          Column(
            children: [
              SizedBox(
                height: height / 50,
              ),
              Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _data.length + (_isLoading ? 1 : 0),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    if (index < _data.length) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: height / 60,
                                  left: width / 50,
                                  right: width / 50),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: notifire.gettabwhitecolor),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 20,
                                      vertical: height / 80),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              textStyleSubTitle(
                                                  "Nomor Invoice"),
                                              textStyleTitle(
                                                  _data[index]["code"],
                                                  fontSize: height / 50)
                                            ],
                                          )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          textStyleSubTitle("Jatuh Tempo"),
                                          textStyleTitle(
                                              Helpers.dateTimeToFormat(
                                                  _data[index]["invoice_date"],
                                                  format: "d MMM y"),
                                              fontSize: height / 50)
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text('Please wait its loading...'));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      )),
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
      final dynamic get = await client.getPaylaterInvoice(
          'Bearer ${SharedPrefs().token}',
          queries: queries);

      List<dynamic> newData = get["data"];
      print(newData);
      setState(() {
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

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }
}
