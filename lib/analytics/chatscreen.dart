import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/colornotifire.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
  void initState() {
    super.initState();
  }

  List<ChartData> chartData = [
    const ChartData('Mon', 24),
    const ChartData('Tue', 20),
    const ChartData('Wed', 27),
    const ChartData('Thu', 57),
    const ChartData('Fri', 30),
    const ChartData('Sat', 41),
    const ChartData('Sun', 20),
    const ChartData('Mon', 30),
  ];

  List historyimg = [
    "images/starbuckscoffee.png",
    "images/spotify.png",
    "images/netflix.png"
  ];

  int progressValue = 20;

  List recentimg = [
    "images/chart3.png",
    "images/chart4.png",
    "images/chart5.png"
  ];
  List recentname = [
    CustomStrings.grocery,
    CustomStrings.fooddrink,
    CustomStrings.entertaiment
  ];
  List historyname = [
    CustomStrings.starbuckscoffee,
    CustomStrings.spotifypremium,
    CustomStrings.spotifypremium
  ];
  List recentcolor = [
    Colors.green,
    Colors.red,
    Colors.red,
  ];
  List recentamount = ["+\$24.000", "-\$64.000", "-\$21.000"];
  List historycolor = [
    Colors.red,
    Colors.green,
    Colors.green,
  ];

  List historyamount = ["-\$46.000", "+\$17.000", "+\$25.000"];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 40,
            ),
            Row(
              children: [
                Container(
                  height: height / 12,
                  width: width / 2.5,
                  decoration: BoxDecoration(
                    color: notifire.getPrimaryPurpleColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 40),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/income.png",
                          height: height / 20,
                        ),
                        SizedBox(
                          width: width / 80,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 80,
                            ),
                            Text(
                              CustomStrings.income,
                              style: TextStyle(
                                  color: notifire.getdarkgreycolor,
                                  fontSize: height / 60,
                                  fontFamily: 'Gilroy Medium'),
                            ),
                            SizedBox(
                              height: height / 100,
                            ),
                            Text(
                              "\$.1.000.000",
                              style: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 60,
                                  fontFamily: 'Gilroy Bold'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: height / 12,
                  width: width / 2.5,
                  decoration: BoxDecoration(
                    color: notifire.getPrimaryPurpleColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 40),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/outcome.png",
                          height: height / 20,
                        ),
                        SizedBox(
                          width: width / 80,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 80,
                            ),
                            Text(
                              CustomStrings.outcome,
                              style: TextStyle(
                                  color: notifire.getdarkgreycolor,
                                  fontSize: height / 60,
                                  fontFamily: 'Gilroy Medium'),
                            ),
                            SizedBox(
                              height: height / 100,
                            ),
                            Text(
                              "\$1.000.000",
                              style: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 60,
                                  fontFamily: 'Gilroy Bold'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 80,
            ),
            columnchart(),
            SizedBox(
              height: height / 60,
            ),
            Row(
              children: [
                Text(
                  CustomStrings.recent,
                  style: TextStyle(
                      color: notifire.getdarkscolor,
                      fontFamily: 'Gilroy Bold',
                      fontSize: height / 50),
                ),
              ],
            ),
            SizedBox(
              height: height / 60,
            ),
            Container(
              height: height / 3.6,
              color: Colors.transparent,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: recentimg.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: height / 80),
                  child: Container(
                    height: height / 12,
                    width: width,
                    decoration: BoxDecoration(
                      color: notifire.getdarkwhitecolor,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 30),
                      child: Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: 50,
                            height: 40,
                            child: Image.asset(recentimg[index]),
                          ),
                          SizedBox(
                            width: width / 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 60,
                              ),
                              Text(
                                recentname[index],
                                style: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontFamily: 'Gilroy Bold',
                                    fontSize: height / 50),
                              ),
                              SizedBox(
                                height: height / 300,
                              ),
                              Text(
                                CustomStrings.octnov,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Gilroy Medium',
                                    fontSize: height / 60),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            recentamount[index],
                            style: TextStyle(
                                color: recentcolor[index],
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 60,
            ),
            Row(
              children: [
                Text(
                  CustomStrings.historytransactions,
                  style: TextStyle(
                      color: notifire.getdarkscolor,
                      fontFamily: 'Gilroy Bold',
                      fontSize: height / 50),
                ),
              ],
            ),
            SizedBox(
              height: height / 60,
            ),
            Container(
              height: height / 3.6,
              color: Colors.transparent,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: historyimg.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: height / 80),
                  child: Container(
                    height: height / 12,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      color: notifire.getdarkwhitecolor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 30),
                      child: Row(
                        children: [
                          Image.asset(
                            historyimg[index],
                            height: height / 25,
                          ),
                          SizedBox(
                            width: width / 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 60,
                              ),
                              Text(
                                historyname[index],
                                style: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontFamily: 'Gilroy Bold',
                                    fontSize: height / 50),
                              ),
                              SizedBox(
                                height: height / 300,
                              ),
                              Text(
                                CustomStrings.octnov,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Gilroy Medium',
                                    fontSize: height / 60),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: height / 60,
                              ),
                              Text(
                                historyamount[index],
                                style: TextStyle(
                                    color: historycolor[index],
                                    fontFamily: 'Gilroy Bold',
                                    fontSize: height / 50),
                              ),
                              SizedBox(
                                height: height / 300,
                              ),
                              Text(
                                "Order ID: ***ase21",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Gilroy Medium',
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
            SizedBox(
              height: height / 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget columnchart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(interval: 10),
      annotations: const <CartesianChartAnnotation>[
        CartesianChartAnnotation(
            coordinateUnit: CoordinateUnit.percentage,
            region: AnnotationRegion.plotArea,
            widget: Text(
              '',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            x: '50%',
            y: '50%')
      ],
      // series: <ChartSeries<ChartData, String>>[
      //   ColumnSeries<ChartData, String>(
      //       color: notifire.getbluecolor,
      //       borderRadius: const BorderRadius.all(Radius.circular(10)),
      //       dataSource: chartData,
      //       xValueMapper: (ChartData data, _) => data.x,
      //       yValueMapper: (ChartData data, _) => data.y)
      // ],
    );
  }
}

class ChartData {
  const ChartData(this.x, this.y);

  final String x;
  final int y;
}
