import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/media.dart';

Widget textStyleTitle(text, {fontSize}){
  return Text(
    text,
    style: TextStyle(
      color: Colors.black,
      fontFamily: 'Gilroy Bold',
      fontSize: fontSize ?? height / 60,
    ),
  );
}

Widget textStyleSubTitle(text, {fontSize}){
  return Text(
    text,
    style: TextStyle(
      color: Colors.black,
      fontFamily: 'Gilroy',
      fontSize: fontSize ?? height / 60,
    ),
  );
}