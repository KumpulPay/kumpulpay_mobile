import 'package:flutter/material.dart';
import 'package:kumpulpay_mobile/data/my_colors.dart';
import 'package:kumpulpay_mobile/route/auth/login.dart';
import 'package:kumpulpay_mobile/widget/my_text.dart';

class LoginPortalRoute extends StatefulWidget{
  
  LoginPortalRoute();

  @override
  LoginPortalState createState() => new LoginPortalState();
}

class LoginPortalState extends State<LoginPortalRoute> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.grey_5,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.white)),
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
                  Text("Selamat Datang",
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
                            SizedBox(height: 25),
                            TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "USERNAME",
                                  labelStyle: MyText.caption(context)),
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
                                  "Daftar Sekarang",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder:  (context) => LoginRoute()));
                                },
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              children: <Widget> [
                                Flexible(child: 
                                  Divider(
                                    color: MyColors.grey_40,
                                    thickness: 1.0,
                                    endIndent: 25.0,
                                  ),
                                ),
                                Text("ATAU"),
                                Flexible(child: 
                                  Divider(
                                    color: MyColors.grey_40,
                                    thickness: 1.0,
                                    indent: 25,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 40),
                            Text("Sudah Punya Akun?"),
                            SizedBox(height: 8),
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
                                  "Masuk Disini",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginRoute()));
                                },
                              ),
                            ),
                            SizedBox(height: 30,)
                          ],
                        ),
                      )),
                  Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}