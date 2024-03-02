import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kumpulpay_mobile/data/img.dart';
import 'package:kumpulpay_mobile/model/intro.dart';
import 'package:kumpulpay_mobile/route/auth/login.dart';
import 'package:kumpulpay_mobile/route/auth/login_portal.dart';
import 'dart:convert';
import 'dart:developer';

import 'widget/my_text.dart';
import 'data/my_colors.dart';

class IntroRoute extends StatefulWidget{

  IntroRoute();
  
  @override
  IntroState createState() => new IntroState();

  
}

class IntroState extends State<IntroRoute> {

  List<Map<String, dynamic>> introData = [
    {
      "image": "intro_01.png",
      "background": "",
      "title": "Kumpul Produk Digital",
      "brief": "Beli pulsa dan banyak produk digital lainnya kami kumpkan disini"
    },
    {
      "image": "intro_02.png",
      "background": "",
      "title": "Transaksi Mudah",
      "brief": "Lebih mudah pakai KumpulPay transaksi cepat pembayaran anti ribet"
    },
    {
      "image": "intro_03.png",
      "background": "",
      "title": "Pendaftaran gratis",
      "brief": "Gratis biaya pendaftaran dan tanpa syarat"
    }
  ];

  PageController pageController = PageController(
    initialPage: 0,
  );
  int page = 0;
  bool isLast = false;

  
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(color: Colors.grey[100])
      ),
      body: Container(
        width: double.infinity, height: double.infinity,
        child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                PageView(
                  onPageChanged: onPageViewChange,
                  controller: pageController,
                  children: buildPageViewItem(),
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: MyColors.grey_40),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 60,
              child: Align(
                alignment: Alignment.topCenter,
                child: buildDots(context),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: MyColors.grey_10,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0))),
              child: Text(isLast ? "GOT IT" : "NEXT",
                  style: MyText.subhead(context)!.copyWith(
                      color: MyColors.grey_90, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (isLast) {
                  // Navigator.pop(context);
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => LoginPortalRoute())
                  );
                  return;
                }
                pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
            ),
          )
        ]),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    isLast = _page == introData.length - 1;
    setState(() {});
  }

  List<Widget> buildPageViewItem() {
    List<Widget> widgets = [];
    for (Map wz in introData) {
      var title = wz['title'].toString();
      var brief = wz['brief'].toString();
      var image = wz['image'].toString();
      print('dataaa: $image' );
      
      Widget wg = Container(
        // padding: EdgeInsets.all(35),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Wrap(
          children: <Widget>[
            Container(
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(Img.get(image), width: double.infinity, height: 450,),
                        Text(title,
                            style: MyText.medium(context).copyWith(
                                color: MyColors.grey_80,
                                fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: Text(brief,
                              textAlign: TextAlign.center,
                              style: MyText.subhead(context)!
                                  .copyWith(color: MyColors.grey_60)),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      );
      widgets.add(wg);
    }
    return widgets;
  }

  Widget buildDots(BuildContext context) {
    Widget widget;

    List<Widget> dots = [];
    for (int i = 0; i < introData.length; i++) {
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 8,
        child: CircleAvatar(
          backgroundColor: page == i ? Colors.orange[400] : MyColors.grey_20,
        ),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }
}