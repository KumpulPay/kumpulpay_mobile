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
  String get refreshToken => _sharedPrefs.getString("token_refresh_api") ?? "";
  set refreshToken(String value) {
    _sharedPrefs.setString("token_refresh_api", value);
  }
  String get deviceToken => _sharedPrefs.getString("device_token") ?? "";
  set deviceToken(String value) {
    _sharedPrefs.setString("device_token", value);
  }

  String get fcmTokenMobile => _sharedPrefs.getString("fcm_token_mobile") ?? "";
  set fcmTokenMobile(String value) {
    _sharedPrefs.setString("fcm_token_mobile", value);
  }

  dynamic get googleProfile => _sharedPrefs.get("google_profile");
  set googleProfile(dynamic value) {
    _sharedPrefs.setString("google_profile", value);
  }

  dynamic get userDataObj {
    String? data = _sharedPrefs.getString("user_data");
    if (data != null) {
      dynamic userData = jsonDecode(data);
      return userData;
    }
    return null;
  }
  String get userData => _sharedPrefs.getString("user_data") ?? "";
  set userData(String value) {
    _sharedPrefs.setString("user_data", value);
  }

  // String get pinTransaction {
  //   Map<String, dynamic> userData = jsonDecode(SharedPrefs().userData);
  //   return userData['pin_transaction'];
  // }

  String get pinTransaction {
    String? data = _sharedPrefs.getString("user_data");
    if (data != null) {
      Map<String, dynamic> userData = jsonDecode(data);
      return userData['pin_transaction'] ?? "";
    }
    return "";
  }

  double get limitsAvailable => _sharedPrefs.getDouble("limits_available") ?? 0;
  set limitsAvailable(double value) {
    _sharedPrefs.setDouble("limits_available", value);
  }

  double get balanceAvailable => _sharedPrefs.getDouble("balance_available") ?? 0;
  set balanceAvailable(double value) {
    _sharedPrefs.setDouble("balance_available", value);
  }

  Future<void> clearAllData() async {
    await _sharedPrefs.clear();
  }

}
