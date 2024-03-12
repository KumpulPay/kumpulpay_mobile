import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'media.dart';

class Customtextfilds {
  static Widget textField(
      textclr, hintclr, borderclr, img, hinttext, fillcolor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 18),
      child: Container(
        color: Colors.transparent,
        height: height / 15,
        child: TextField(
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillcolor,
            hintText: hinttext,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height / 100, horizontal: height / 70),
              child: Image.asset(
                img,
                height: height / 30,
              ),
            ),
            hintStyle: TextStyle(color: hintclr, fontSize: height / 60),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderclr),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomtextFormfilds {
  // static bool is_email = false;
  static RegExp get _emailRegex => RegExp(r'^\S+@\S+$');
  static Widget textField(textclr, hintclr, borderclr, img, hinttext, fillcolor,
  {is_email=false, is_password=false}) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 18),
      child: Container(
        color: Colors.transparent,
        height: height / 15,
        child: TextFormField(
          validator: (value){
            if (value == '') {
                return 'Wajib';
            }
            if (is_email) {
                return Helpers.validateEmail(value);
            }
            if (is_password) {
                return Helpers.validatePassword(value);
            }
          },
          // controller: _controller,
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            // errorText: _validate ? "Value Can't Be Empty" : null,
            filled: true,
            fillColor: fillcolor,
            hintText: hinttext,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height / 100, horizontal: height / 70),
              child: Image.asset(
                img,
                height: height / 30,
              ),
            ),
            hintStyle: TextStyle(color: hintclr, fontSize: height / 60),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderclr),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

}

class CustomtextFormBuilderfilds {
  // static bool is_email = false;
  static RegExp get _emailRegex => RegExp(r'^\S+@\S+$');
  static Widget textField(
    textclr, 
    hintclr, 
    borderclr, 
    img, 
    hinttext, 
    fillcolor,
    {name, is_email = false, is_password = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 18),
      child: Container(
        color: Colors.transparent,
        height: height / 15,
        child: FormBuilderTextField(
          name: name,
          validator: (value) {
            
            if (value == '') {
              return 'Wajib';
            }
            if (is_email) {
              print('value: $value');
              return Helpers.validateEmail(value);
            }
            if (is_password) {
              // return Helpers.validatePassword(value);
            }
          },
          // controller: _controller,
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            // errorText: _validate ? "Value Can't Be Empty" : null,
            filled: true,
            fillColor: fillcolor,
            hintText: hinttext,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height / 100, horizontal: height / 70),
              child: Image.asset(
                img,
                height: height / 30,
              ),
            ),
            hintStyle: TextStyle(color: hintclr, fontSize: height / 60),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderclr),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
