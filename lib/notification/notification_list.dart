import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kumpulpay/repository/sqlite/notification_dao.dart';
import 'package:kumpulpay/repository/sqlite/notification_entity.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationList extends StatefulWidget {
  static String routeName = '/notification';
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
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

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final int itemsPerPage = 10;
  int currentPage = 0;
  List<NotificationEntity> notifList = [];

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

  Future<void> _loadData() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final NotificationDao dao = GetIt.instance.get<NotificationDao>();
    // final offset = currentPage * itemsPerPage;

    final results = await dao.findAll(itemsPerPage, currentPage);

    setState(() {
      notifList.addAll(results);
      currentPage += itemsPerPage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    print('print: ${notifList.length}');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        title: Text(
          "Notifikasi",
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
          child: Padding(
            padding: EdgeInsets.only(left: width / 20, right: width / 20, top: height / 40),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: notifList.length + (_isLoading ? 1 : 0),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          if (index < notifList.length) {
                            final item = notifList[index];
                            return Column(
                              children: [
                                Container(
                                  width: width,
                                  color: Colors.transparent,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // color: Colors.amber,
                                        height: height / 20,
                                        width: width / 10,
                                        child:  Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Image.asset(
                                              "images/successfull.png"),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 30,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: TextStyle(
                                                  color: notifire.getdarkscolor,
                                                  fontFamily: 'Gilroy Bold',
                                                  fontSize: height / 54),
                                            ),
                                            SizedBox(
                                              height: height / 100,
                                            ),
                                            Text(
                                              item.subtitle,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy Medium',
                                                  fontSize: height / 55),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              Helpers.dateTimeToFormat(
                                                  item.timestamp.toString(),
                                                  format:
                                                      "dd MMM yy | hh:mm:ss"),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: height / 60,
                                                  fontFamily: 'Gilroy Medium'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height / 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(),
                                  child: Divider(
                                    color: notifire.getdarkgreycolor
                                        .withOpacity(0.1),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 100,
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                                child: Text('Please wait its loading...'));
                          }
                        }))
              ],
            ),
          )),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }
}
