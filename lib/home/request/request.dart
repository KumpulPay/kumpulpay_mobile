import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colornotifire.dart';
import '../../utils/media.dart';
import '../../utils/string.dart';
import 'all.dart';

class Request extends StatefulWidget {
  const Request({Key? key}) : super(key: key);

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> with SingleTickerProviderStateMixin {
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

  TabController? controller;
  List<Widget> tabs = [
    const All(),
    const All(),
    const All(),
    const All(),
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
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
          CustomStrings.requestpayment,
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: notifire.getbluecolor,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
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
                  children: [
                    SizedBox(
                      height: height / 40,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 20),
                      child: Container(
                        color: Colors.transparent,
                        width: width,
                        height: height / 15,
                        child: TextField(
                          autofocus: false,
                          style: TextStyle(
                            fontSize: height / 50,
                            color: notifire.getdarkscolor,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search contact..",
                            filled: true,
                            fillColor: notifire.getprimerydarkcolor,
                            hintStyle: TextStyle(
                                color: Colors.grey, fontSize: height / 60),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 50,
                                  vertical: height / 60),
                              child: Image.asset(
                                "images/search.png",
                                color: notifire.getdarkgreycolor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: notifire.getbluecolor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffd3d3d3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 20),
                      child: Container(
                        height: height / 1.2,
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: notifire.gettabcolor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.all(height / 200),
                                child: TabBar(
                                  labelStyle: const TextStyle(
                                      fontFamily: 'Gilroy Bold'),
                                  indicator: BoxDecoration(
                                      color: notifire.gettabwhitecolor,
                                      borderRadius: BorderRadius.circular(10)),
                                  indicatorColor: notifire.getbluecolor,
                                  controller: controller,
                                  labelColor: notifire.getdarkscolor,
                                  unselectedLabelColor: Colors.grey,
                                  dividerColor: Colors.transparent,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: const [
                                    Tab(
                                      text: CustomStrings.all,
                                    ),
                                    Tab(text: CustomStrings.favorite),
                                    Tab(text: CustomStrings.bank),
                                    Tab(text: CustomStrings.ewallet),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: controller,
                                children: tabs.map((tab) => tab).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget serarchtextField(textclr, hinttext) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 18),
      child: Container(
        color: Colors.transparent,
        height: height / 15,
        child: TextField(
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: notifire.getprimerydarkcolor,
            hintText: hinttext,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffixIcon: Icon(
              Icons.add_road,
              color: notifire.getbluecolor,
            ),
            hintStyle: TextStyle(color: Colors.grey, fontSize: height / 55),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
