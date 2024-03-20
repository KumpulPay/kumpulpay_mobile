import 'package:flutter/material.dart';
import 'media.dart';

class Custombutton {
  static Widget button(clr,text,wid){
    return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            color: clr,
          ),
          height: height / 15,
          width: wid,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height / 50,
                  fontFamily: 'Gilroy Medium'),
            ),
          ),
        ),
    );
  }

  static Widget button2(clr, txt, clr2) {
    return Container(
      height: height / 20,
      width: width / 3.5,
      decoration: BoxDecoration(
        color: clr,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          txt,
          style: TextStyle(
              color: clr2, fontSize: height / 60, fontFamily: 'Gilroy Bold'),
        ),
      ),
    );
  }
}