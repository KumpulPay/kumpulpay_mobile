import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/home/home.dart';
import 'package:kumpulpay/login/login.dart';
import 'package:kumpulpay/notification/notification_list.dart';
import 'package:kumpulpay/test.dart';
import 'package:kumpulpay/transaction/history_all.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/profile.dart';

class Bottombar extends StatefulWidget {
  static String routeName = '/bottom_bar';
  const Bottombar({Key? key}) : super(key: key);

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  late ColorNotifire notifire;
  int currentTab = 0;
  bool keyboardOpen = false;

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Home();

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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _onWillPop(),
      child: Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: notifire.getbackcolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          child: Image.asset(
            "images/logo_app/playstore.png",
            height: height / 25,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => const Scan(),
                builder: (context) => const Test(),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: notifire.getprimerycolor,
          notchMargin: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          currentScreen = const Home();
                          currentTab = 0;
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentTab == 0
                            ? Image.asset(
                                "images/home1.png",
                                height: height / 34,
                                color: notifire.getPrimaryPurpleColor,
                              )
                            : Image.asset(
                                "images/home.png",
                                height: height / 33,
                                color: notifire.getdarkscolor,
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          currentScreen = const HistoryAll();
                          currentTab = 1;
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentTab == 1
                            ? Image.asset(
                                "images/activity.png",
                                height: height / 33,
                                color: notifire.getPrimaryPurpleColor,
                              )
                            : Image.asset("images/activity.png",
                                height: height / 33,
                                color: notifire.getdarkscolor),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          currentScreen = const NotificationList();
                          currentTab = 3;
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentTab == 3
                            ? Image.asset(
                                "images/notification.png",
                                height: height / 30,
                                color: notifire.getPrimaryPurpleColor,
                              )
                            : Image.asset("images/notification.png",
                                height: height / 30,
                                color: notifire.getdarkscolor),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          currentScreen = const Profile();
                          currentTab = 4;
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentTab == 4
                            ? Image.asset(
                                "images/profile1.png",
                                height: height / 30,
                                color: notifire.getPrimaryPurpleColor,
                              )
                            : Image.asset("images/profile.png",
                                height: height / 30,
                                color: notifire.getdarkscolor),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: notifire.getprimerycolor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                height: height / 3,
                child: Column(
                  children: [
                    SizedBox(
                      height: height / 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Spacer(),
                          Icon(
                            Icons.clear,
                            color: notifire.getdarkscolor,
                          ),
                          SizedBox(
                            width: width / 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Text(
                      CustomStrings.sure,
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontFamily: 'Gilroy Bold',
                        fontSize: height / 40,
                      ),
                    ),
                    Text(
                      CustomStrings.log,
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontFamily: 'Gilroy Bold',
                        fontSize: height / 40,
                      ),
                    ),
                    SizedBox(
                      height: height / 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: height / 18,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          color: notifire.getPrimaryPurpleColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Tidak',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 55),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 100,
                    ),
                    GestureDetector(
                      onTap: () {
                        SharedPrefs().clearAllData();
                        Navigator.pushNamedAndRemoveUntil(
                            context, Login.routeName, (route) => false);
                      },
                      child: Container(
                        height: height / 18,
                        width: width / 2.5,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            CustomStrings.logout,
                            style: TextStyle(
                                color: const Color(0xffEB5757),
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 55),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )) ??
        false;
  }
}
