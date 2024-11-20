import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


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

  static Widget setNetWorkImage(String images, Widget placeholder, {double? height_, double? width_}) {
    return Center(
      child: images.isNotEmpty
          ? Image.network(
              images,
              height: height_,
              width: width_,
              fit: BoxFit
                  .contain,
              errorBuilder: (context, error, stackTrace) {
                return placeholder;
              },
            )
          : placeholder,
    );
  }

  static Widget setCachedNetworkImage(String images, Widget placeholder,
      {double? height_, double? width_}) {
    return Center(
      child: images.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: images,
              height: height_,
              width: width_,
              fit: BoxFit.cover, 
              errorWidget: (context, url, error) {
                return placeholder;
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

}
