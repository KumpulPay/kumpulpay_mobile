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
  Map<String, List<NotificationEntity>> groupedNotifications = {};

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
    final results = await dao.findAll(itemsPerPage, currentPage);

    setState(() {
      notifList.addAll(results);
      groupedNotifications = _groupNotificationsByDate(notifList);
      currentPage += itemsPerPage;
      _isLoading = false;
    });
  }

  Map<String, List<NotificationEntity>> _groupNotificationsByDate(
      List<NotificationEntity> notifications) {
    Map<String, List<NotificationEntity>> grouped = {};
    for (var notif in notifications) {
      String dateKey = Helpers.dateTimeToFormat(
        notif.timestamp.toString(),
        format: "dd MMM yyyy",
      );
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notif);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
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
            padding: EdgeInsets.only(left: width / 20, right: width / 20, top: height / 60),
            child: _buildNotificationList(),
          )),
    );
  }

  Widget _buildNotificationList() {
    if (_isLoading && notifList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: groupedNotifications.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < groupedNotifications.length) {
          String dateKey = groupedNotifications.keys.elementAt(index);
          List<NotificationEntity> items = groupedNotifications[dateKey]!;

          return _buildNotificationSection(dateKey, items);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildNotificationSection(
      String dateKey, List<NotificationEntity> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            dateKey,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: notifire.getdarkscolor,
            ),
          ),
        ),
        // const Divider(),

        // Section Items
        Column(
          children: items.map((notif) {
            return _buildNotificationItem(notif);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(NotificationEntity item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon or Image
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
            width: MediaQuery.of(context).size.width / 10,
            child: Image.asset("images/logo_app/disabled_kumpulpay_logo.png"),
          ),
          const SizedBox(width: 8.0),

          // Notification Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: notifire.getdarkscolor,
                    fontFamily: 'Gilroy Bold',
                    fontSize: MediaQuery.of(context).size.height / 54,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Gilroy Medium',
                    fontSize: MediaQuery.of(context).size.height / 55,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  Helpers.dateTimeToFormat(
                    item.timestamp.toString(),
                    format: "hh:mm:ss",
                  ),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.height / 60,
                    fontFamily: 'Gilroy Medium',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }
}
