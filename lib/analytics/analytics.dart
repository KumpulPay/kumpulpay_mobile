import 'package:flutter/material.dart';
import 'package:kumpulpay/analytics/chatscreen.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';
import 'chatround.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics>
    with SingleTickerProviderStateMixin {
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
  DateTime selectedDate = DateTime.now();

  int selectedindex = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  List img = ["images/chart1.png", "images/chat2.png"];

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      week(),
      week(),
      week(),
    ];
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.transparent),
        centerTitle: true,
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        title: Text(
          CustomStrings.analytics,
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
        actions: [
          GestureDetector(
              onTap: () async {
                final DateTime? dateTime = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (dateTime != null) {
                  setState(() {
                    selectedDate.toString().split(" ").first;
                  });
                }
              },
              child: Image.asset(
                'images/calendar.png',
                scale: 3.5,
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
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
                  height: height / 50,
                ),
                Row(
                  children: [
                    SizedBox(width: width / 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CustomStrings.totalwallet,
                          style: TextStyle(
                              fontFamily: 'Gilroy Medium',
                              color: notifire.getdarkscolor,
                              fontSize: height / 60),
                        ),
                        SizedBox(
                          height: height / 200,
                        ),
                        Text(
                          "\$.12.000.000",
                          style: TextStyle(
                              fontFamily: 'Gilroy Bold',
                              color: notifire.getdarkscolor,
                              fontSize: height / 40),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: width / 3.1,
                      height: height / 17,
                      decoration: BoxDecoration(
                          color: notifire.gettabcolor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedindex = index;
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: height / 20,
                                    width: width / 8,
                                    decoration: BoxDecoration(
                                      color: selectedindex == index
                                          ? notifire.gettabwhitecolor
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        img[index],
                                        color: notifire.getbluecolor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: width / 20)
                  ],
                ),
                SizedBox(
                  height: height / 50,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Container(
                    height: height / 1.3,
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
                              labelStyle:
                                  const TextStyle(fontFamily: 'Gilroy Bold'),
                              indicator: BoxDecoration(
                                  color: notifire.gettabwhitecolor,
                                  borderRadius: BorderRadius.circular(10)),
                              indicatorColor: notifire.getbluecolor,
                              controller: controller,
                              labelColor: notifire.getdarkscolor,
                              dividerColor: Colors.transparent,
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelColor: Colors.grey,
                              tabs: const [
                                Tab(text: CustomStrings.weekly),
                                Tab(text: CustomStrings.monthly),
                                Tab(text: CustomStrings.yearly),
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
      ),
    );
  }

  Widget week() {
    return selectedindex == 0 ? const ChatScreen() : const ChatRound();
  }
}
