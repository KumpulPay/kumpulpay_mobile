import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kumpulpay/login/login.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onbonding extends StatefulWidget {
  static String routeName = '/intro';
  const Onbonding({Key? key}) : super(key: key);

  @override
  State<Onbonding> createState() => _OnbondingState();
}

class _OnbondingState extends State<Onbonding> {
  late ColorNotifire notifire;

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final int _numPages = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
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

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 20.0,
      width: isActive ? 20.0 : 20.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: isActive
              ? const AssetImage("images/darkstar.png")
              : const AssetImage("images/star.png"),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: notifire.getprimerycolor,
                  height: height,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      SingleChildScrollView(
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
                                  height: height / 20,
                                ),
                                Image.asset(
                                  "images/intro_01.png",
                                  height: height / 2,
                                ),

                                SizedBox(
                                  height: height / 100,
                                ),
                                txtTitle(CustomStrings.intro1Title),
                                
                                SizedBox(
                                  height: height / 30,
                                ),
                                txtSubTitle(CustomStrings.intro1Description),
                                
                              ],
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
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
                                  height: height / 20,
                                ),
                                Image.asset(
                                  "images/intro_02.png",
                                  height: height / 2,
                                ),

                                SizedBox(
                                  height: height / 100,
                                ),
                                txtTitle(CustomStrings.intro2Title),

                                SizedBox(
                                  height: height / 30,
                                ),
                                txtSubTitle(CustomStrings.intro2Description),
                                
                              ],
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
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
                                  height: height / 20,
                                ),
                                Image.asset(
                                  "images/intro_03.png",
                                  height: height / 2,
                                ),

                                SizedBox(
                                  height: height / 100,
                                ),
                                txtTitle(CustomStrings.intro3Title),

                                SizedBox(
                                  height: height / 30,
                                ),
                                txtSubTitle(CustomStrings.intro3Description),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_currentPage == 0) ...{
              Column(
                children: [
                  SizedBox(
                    height: height / 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Login.routeName, (route) => false);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              CustomStrings.skip,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Bold',
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height / 1.45),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                          duration: const Duration(microseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: Center(
                      child: Image.asset(
                        "images/onbonding1button.png",
                        height: height / 10,
                      ),
                    ),
                  ),
                ],
              ),
            } else if (_currentPage == 1) ...{
              Column(
                children: [
                  SizedBox(
                    height: height / 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Login.routeName, (route) => false);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              CustomStrings.skip,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Bold',
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height / 1.45),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                          duration: const Duration(microseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: Center(
                      child: Image.asset(
                        "images/onbonding2button.png",
                        height: height / 10,
                      ),
                    ),
                  ),
                ],
              ),
            } else if (_currentPage == 2) ...{
              Column(
                children: [
                  SizedBox(
                    height: height / 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                           Navigator.pushNamedAndRemoveUntil(
                                context, Login.routeName, (route) => false);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              CustomStrings.skip,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Bold',
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height / 1.45),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Login.routeName, (route) => false);
                    },
                    child: Center(
                      child: Image.asset(
                        "images/onbonding3button.png",
                        height: height / 10,
                      ),
                    ),
                  ),
                ],
              ),
            }
          ],
        ),
      ),
    );
  }

  Widget txtTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 10),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: 'Gilroy Bold',
            color: notifire.getdarkscolor,
            fontSize: height / 40),
      ),
    );
  }

  Widget txtSubTitle(String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 10),
      child: Text(
        subTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Gilroy Medium',
            color: notifire.getdarkgreycolor,
            fontSize: height / 50),
      ),
    );
  }
}
