
import 'package:intl/intl.dart';

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
    const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    final regex = RegExp(pattern);
    return value!.isNotEmpty && !regex.hasMatch(value) 
      ? 'Password tidak valid' : null;
  }

  static String dateTimeToFormat(String data, {String format="dd-MM-yyyy"}){
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(DateTime.parse(data));
    return formatted;
  }

  static String currencyFormatter(double value, {locale="id_ID", symbol="Rp", decimalDigits=0}){
    NumberFormat currencyFormatter = NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: decimalDigits);
    return currencyFormatter.format(value);
  }
  static double removeCurrencyFormatter(String value,   {locale="id_ID", symbol="Rp", decimalDigits=0}){
    NumberFormat formatter = NumberFormat('#,##0', locale);
    double number = formatter.parse(value).toDouble(); 
    return number;
  }

  // static String titlePpobProduct(String value) {
    
  //   return currencyFormatter.format(value);
  // }

}