import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'media.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Dinamistextfilds {
  static Widget textField(
      {txtClr,
      histClr,
      hintTxt,
      borderClr,
      fillClr,
      enabled = true,
      controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 18),
      child: Container(
        color: Colors.transparent,
        height: height / 15,
        child: TextField(
          controller: controller,
          enabled: enabled,
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: txtClr,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillClr,
            hintText: hintTxt,
            hintStyle: TextStyle(color: histClr, fontSize: height / 60),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderClr),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffd3d3d3)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

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
  static Widget textField(textclr, hintclr, borderclr, img, hinttext, fillcolor,
      {is_email = false, is_password = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 18),
      child: Container(
        color: Colors.transparent,
        height: height / 15,
        child: TextFormField(
          validator: (value) {
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

class FormBuilderTextFieldCustom {
  static Widget type1(textclr, hintclr, borderclr, fillcolor,
      {hintText,
      labelText,
      name = "",
      prefixIcon,
      suffixIcon,
      suffixIconInteractive,
      isEmail = false,
      isPassword = false,
      initialValue,
      validator,
      maxLength,
      keyboardType,
      textInputAction,
      onSubmitted}) {
    return FormBuilderTextField(
      name: name,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction??TextInputAction.next,
      maxLength: maxLength,
      onSubmitted: (value) {
        onSubmitted(value);
      },
      style: TextStyle(
        fontSize: height / 50,
        color: textclr,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillcolor,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 100, horizontal: height / 70),
                child: Image.asset(
                  prefixIcon,
                  height: height / 30,
                ),
              )
            : null,
        suffixIcon: suffixIconInteractive != null ? suffixIconInteractive : suffixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 50, horizontal: height / 70),
                child: Image.asset(
                  suffixIcon,
                  height: height / 50,
                ),
              )
            : suffixIcon,
        hintStyle: TextStyle(color: hintclr, fontSize: height / 60),    
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(10)),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  // with suffixIcon interactive
  // static Widget type2(){
    
  // }
}
class CustomtextFormBuilderfilds {
  static Widget textField(textclr, hintclr, borderclr, fillcolor, hinttext,
      {labelText,
      name = "",
      img,
      suffixIcon,
      isEmail = false,
      isPassword = false,
      initialValue,
      validator,
      isRequired = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 18),
      child: Container(
        color: Colors.transparent,
        height: height / 15,
        child: FormBuilderTextField(
          initialValue: initialValue,
          name: name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Wajib';
            }
            if (isEmail) {
              return Helpers.validateEmail(value);
            }
            if (isPassword) {
              // return Helpers.validatePassword(value);
            }
            return null;
          },
          autofocus: false,
          style: TextStyle(
            fontSize: height / 50,
            color: textclr,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillcolor,
            hintText: hinttext,
            labelText: labelText,
            prefixIcon: img != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height / 100, horizontal: height / 70),
                    child: Image.asset(
                      img,
                      height: height / 30,
                    ),
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height / 50, horizontal: height / 70),
                    child: Image.asset(
                      suffixIcon,
                      height: height / 50,
                    ),
                  )
                : suffixIcon,
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
            // contentPadding: const EdgeInsets.only(left: 16.0, top: 26.0)
          ),
        
        ),
      ),
    );
  }
}
