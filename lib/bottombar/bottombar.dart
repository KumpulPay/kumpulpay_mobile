import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kumpulpay/home/home.dart';
import 'package:kumpulpay/test.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/wallet/wallets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../analytics/analytics.dart';
import '../card/mycard.dart';
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
                          currentScreen = const Analytics();
                          currentTab = 1;
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentTab == 1
                            ? Image.asset(
                                "images/order1.png",
                                height: height / 33,
                                color: notifire.getPrimaryPurpleColor,
                              )
                            : Image.asset("images/variant.png",
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
                          currentScreen = const Wallets();
                          currentTab = 3;
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentTab == 3
                            ? Image.asset(
                                "images/wallet.png",
                                height: height / 30,
                                color: notifire.getPrimaryPurpleColor,
                              )
                            : Image.asset("images/message1.png",
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
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda ingin keluar dari halaman ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Ya'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
