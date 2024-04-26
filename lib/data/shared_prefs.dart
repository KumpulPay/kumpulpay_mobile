import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;
  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }
  
  String get username => _sharedPrefs.getString("user_name") ?? "";
  set username(String value) {
    _sharedPrefs.setString("user_name", value);
  }

  String get token => _sharedPrefs.getString("token_api") ?? "";
  set token(String value) {
    _sharedPrefs.setString("token_api", value);
  }

  String get fcmTokenMobile => _sharedPrefs.getString("fcm_token_mobile") ?? "";
  set fcmTokenMobile(String value) {
    _sharedPrefs.setString("fcm_token_mobile", value);
  }

  String get userData => _sharedPrefs.getString("user_data") ?? "";
  set userData(String value) {
    _sharedPrefs.setString("user_data", value);
  }

  String get pinTransaction {
    Map<String, dynamic> userData = jsonDecode(SharedPrefs().userData);
    return userData['pin_transaction'];
  }


  double get limitsAvailable => _sharedPrefs.getDouble("limits_available") ?? 0;
  set limitsAvailable(double value) {
    _sharedPrefs.setDouble("limits_available", value);
  }

}
