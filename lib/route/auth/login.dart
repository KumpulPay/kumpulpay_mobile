import 'package:flutter/material.dart';
import 'package:kumpulpay_mobile/data/my_colors.dart';
import 'package:kumpulpay_mobile/route/home/home.dart';
import 'package:kumpulpay_mobile/widget/my_text.dart';


class LoginRoute extends StatefulWidget {
  
  LoginRoute();

  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<LoginRoute> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.grey_5,
      appBar: PreferredSize(preferredSize: Size.fromHeight(0), child: Container(color: Colors.white)),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Text("Sign in",
                      style: MyText.title(context)!.copyWith(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold)),
                  Container(height: 10),
                  Container(height: 4, width: 40, color: Colors.blue[600]),
                  Container(height: 25),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Container(height: 25),
                            TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "USERNAME",
                                  labelStyle: MyText.caption(context)),
                            ),
                            Container(height: 25),
                            TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "PASSWORD",
                                  labelStyle: MyText.caption(context)),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Spacer(),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.transparent),
                                  child: Text("Forgot Password?",
                                      style:
                                          TextStyle(color: MyColors.grey_20)),
                                  onPressed: () {},
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: MyColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20)),
                                ),
                                child: Text(
                                  "Masuk",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeRoute()));
                                },
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    primary: Colors.transparent),
                                child: Text(
                                  "Penguna baru? Daftar disini",
                                  style:
                                      TextStyle(color: MyColors.primaryLight),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}