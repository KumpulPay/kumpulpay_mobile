import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';
import 'color.dart';


class Helpers {
  static String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  static String? validatePassword(String? value) {
    const pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    final regex = RegExp(pattern);
    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Password tidak valid'
        : null;
  }

  static String dateTimeToFormat(String data, {String format = "dd-MM-yyyy"}) {
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(DateTime.parse(data));
    return formatted;
  }

  static String currencyFormatter(double value,
      {locale = "id_ID", symbol = "Rp", decimalDigits = 0}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
        locale: locale, symbol: symbol, decimalDigits: decimalDigits);
    return currencyFormatter.format(value);
  }

  static double removeCurrencyFormatter(String value,
      {locale = "id_ID", symbol = "Rp", decimalDigits = 0}) {
    NumberFormat formatter = NumberFormat('#,##0', locale);
    double number = formatter.parse(value).toDouble();
    return number;
  }

  static Widget setNetWorkImage(String images, {double? height_, double? width_, Widget? placeholder}) {
    return Center(
      child: images.isNotEmpty
          ? Image.network(
              images,
              height: height_,
              width: width_,
              fit: BoxFit
                  .contain,
              errorBuilder: (context, error, stackTrace) {
                return placeholder ??
                    Image.asset("images/logo_app/disabled_kumpulpay_logo.png",
                        height: height / height_);
              },
            )
          : placeholder,
    );
  }

  static Widget setCachedNetworkImage(String images, {double? height_, double? width_, Widget? placeholder}) {
    return Center(
      child: images.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: images,
              height: height_,
              width: width_,
              fit: BoxFit.cover, 
              errorWidget: (context, url, error) {
                return placeholder??
                    Image.asset(
                        "images/logo_app/disabled_kumpulpay_logo.png",
                        height: height / height_);
              },
            )
          : placeholder,
    );
  }

  static String shortenNumber_(double number) {
    if (number >= 1000000000) {
      // Jika angka lebih dari atau sama dengan 1 miliar
      return "${(number / 1000000000).toStringAsFixed(1)}B";
    } else if (number >= 1000000) {
      // Jika angka lebih dari atau sama dengan 1 juta
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      // Jika angka lebih dari atau sama dengan 1 ribu
      return "${(number / 1000).toStringAsFixed(1)}K";
    } else {
      // Jika angka kurang dari 1 ribu
      return number.toString();
    }
  }

  static String shortenNumber(double number) {
    if (number >= 1000000000) {
      return "${number ~/ 1000000000}m"; // Menggunakan operator ~/ untuk pembagian integer
    } else if (number >= 1000000) {
      return "${number ~/ 1000000}jt";
    } else if (number >= 1000) {
      return "${number ~/ 1000}rb";
    } else {
      return number.toString();
    }
  }

  static Future<dynamic> showMbsAlert({required context, required title, required subtitle, typeAlert, txtButton}) {
    Widget image = Icon(
      Icons.check_circle_outline,
      color: Colors.green,
      size: height / 10,
    );
    if (typeAlert == 'info') {
      image = Icon(
        Icons.info_outlined,
        color: blueColor,
        size: height / 10,
      );
    } else if(typeAlert == 'warning'){
      image = Icon(
        Icons.warning_amber_rounded,
        color: Colors.amberAccent,
        size: height / 10,
      );
    } else if (typeAlert == 'danger') {
      image = Icon(
        Icons.dangerous_outlined,
        color: Colors.red,
        size: height / 10,
      );
    }
    return  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: primeryColor,
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: height / 80,
              ),
              Container(
                height: height / 80,
                width: width / 4,
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: height / 50,
              ),
              image,
              SizedBox(
                height: height / 50,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: darkColor,
                              fontFamily: 'Gilroy Bold',
                              fontSize: height / 35),
                        ),
                        SizedBox(height: height / 40),
                        Text(
                          subtitle,
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Gilroy Medium',
                              fontSize: height / 55),
                        ),
                      ],
                    ),
                  )),

              // start button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 40),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: height / 15,
                    width: width,
                    decoration: BoxDecoration(
                      color: primaryPurpleColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        txtButton??'Tutup',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy Bold',
                            fontSize: height / 50),
                      ),
                    ),
                  ),
                ),
              ),
              // end button
            ],
          ),
        );
      },
    );
  }

}
