import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';
import '../utils/string.dart';

class Seealltransaction extends StatefulWidget {
  const Seealltransaction({Key? key}) : super(key: key);

  @override
  State<Seealltransaction> createState() => _SeealltransactionState();
}

class _SeealltransactionState extends State<Seealltransaction> {
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

  List transaction = [
    "images/starbuckscoffee.png",
    "images/spotify.png",
    "images/netflix.png",
    "images/starbuckscoffee.png",
    "images/spotify.png",
    "images/netflix.png",
  ];
  List transactionname = [
    CustomStrings.starbuckscoffee,
    CustomStrings.spotifypremium,
    CustomStrings.netflixpremium,
    CustomStrings.starbuckscoffee,
    CustomStrings.spotifypremium,
    CustomStrings.netflixpremium,
  ];
  List transactioncolor = [
    Colors.red,
    Colors.red,
    Colors.green,
    Colors.red,
    Colors.green,
    Colors.red,
  ];
  List transactionamount = [
    "-\$55.000",
    "+\$25.000",
    "+\$57.000",
    "-\$22.000",
    "-\$18.000",
    "-\$62.000",
  ];
  List transactiondate = [
    "12 Oct 2021 . 16:03",
    "8 Oct 2021 . 12:05",
    "4 Oct 2021 . 09:25",
    "12 Oct 2021 . 16:03",
    "8 Oct 2021 . 12:05",
    "4 Oct 2021 . 09:25",
  ];
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          CustomStrings.alltransaction,
          style: TextStyle(
              fontFamily: "Gilroy Bold",
              color: notifire.getdarkscolor,
              fontSize: height / 40),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 50,
            ),
            Container(
              height: height / 1.15,
              color: Colors.transparent,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: transaction.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 20, vertical: height / 100),
                  child: Container(
                    height: height / 11,
                    width: width,
                    decoration: BoxDecoration(
                      color: notifire.getprimerydarkcolor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 30),
                      child: Row(
                        children: [
                          Container(
                            height: height / 15,
                            width: width / 7,
                            decoration: const BoxDecoration(
                              color: Color(0xffF7F8F9),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                transaction[index],
                                height: height / 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width / 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 70,
                              ),
                              Row(
                                children: [
                                  Text(
                                    transactionname[index],
                                    style: TextStyle(
                                        fontFamily: "Gilroy Bold",
                                        color: notifire.getdarkscolor,
                                        fontSize: height / 55),
                                  ),
                                  // SizedBox(width: width / 7,),
                                ],
                              ),
                              SizedBox(
                                height: height / 100,
                              ),
                              Row(
                                children: [
                                  Text(
                                    transactiondate[index],
                                    style: TextStyle(
                                        fontFamily: "Gilroy Medium",
                                        color: notifire.getdarkgreycolor
                                            .withOpacity(0.6),
                                        fontSize: height / 60),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: height / 70,
                              ),
                              Text(
                                transactionamount[index],
                                style: TextStyle(
                                    fontFamily: "Gilroy Bold",
                                    color: transactioncolor[index],
                                    fontSize: height / 50),
                              ),
                              SizedBox(
                                height: height / 100,
                              ),
                              Text(
                                "Order ID:***ase21",
                                style: TextStyle(
                                    fontFamily: "Gilroy Medium",
                                    color: notifire.getdarkgreycolor
                                        .withOpacity(0.6),
                                    fontSize: height / 60),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
