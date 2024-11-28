import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';

class HelpSupport extends StatefulWidget {
  final String title;
  const HelpSupport(this.title, {Key? key}) : super(key: key);

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {

  late bool _loading = true;
  late ColorNotifire notifire;
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  final TextEditingController _searchController = TextEditingController();    
  List<dynamic> faqList = [];
  List<dynamic> filteredFaqList = List.filled(10, {
    "question": "question",
    "answer": "answer"
  });

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
        _onSearchChanged);
    _fetchFaqData();
  }

  // Fungsi untuk mengambil data FAQ hanya sekali
  void _fetchFaqData() async {
    final response =
        await ApiClient(AppConfig().configDio())
            .getCompanyFaq(authorization: 'Bearer ${SharedPrefs().token}');
    try {
      
      if (response.success) {
        setState(() {
          faqList = response.data;
          filteredFaqList = faqList;
          _loading = false;
        });
      } else {
        setState(() {
          filteredFaqList = [];
        });
      }
    } catch (e) {
      setState(() {
        filteredFaqList = [];
      });
    }
  }

  // Fungsi yang dipanggil setiap ada perubahan input pada pencarian
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredFaqList = faqList
          .where((item) =>
              item['question'].toLowerCase().contains(query) ||
              item['answer'].toLowerCase().contains(query))
          .toList();
    });
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
          'Tanya Jawab (FAQ)',
          style: TextStyle(
            color: notifire.getdarkscolor,
            fontFamily: 'Gilroy Bold',
            fontSize: height / 40,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 50,
                      ),
                      serarchtextField(
                        Colors.black,
                        notifire.getdarkgreycolor,
                        notifire.getbluecolor,
                        CustomStrings.search,
                      ),
                      
                      Skeletonizer(
                        enabled: _loading,
                        child: Accordion(
                          disableScrolling: true,
                          flipRightIconIfOpen: true,
                          contentVerticalPadding: 0,
                          scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                          contentBorderColor: Colors.transparent,
                          maxOpenSections: 1,
                          headerBackgroundColorOpened: Colors.black54,
                          headerPadding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 15),
                          children: [
                            for (var item in filteredFaqList) ...[
                              AccordionSection(
                                sectionClosingHapticFeedback:
                                    SectionHapticFeedback.light,
                                contentBackgroundColor:
                                    notifire.gettabwhitecolor,
                                headerBackgroundColor:
                                    notifire.gettabwhitecolor,
                                header: Text(
                                  item['question'],
                                  style: TextStyle(
                                      color: notifire.getdarkscolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Html(data: item['answer']),
                                contentHorizontalPadding: 20,
                                contentBorderWidth: 1,
                              ),
                            ]
                          ],
                        ),
                      ),
                        
                    ],
                  ),
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
      padding: EdgeInsets.symmetric(horizontal: width / 60),
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
}
