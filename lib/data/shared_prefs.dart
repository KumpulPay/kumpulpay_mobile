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

  String get userData => _sharedPrefs.getString("user_data") ?? "";
  set userData(String value) {
    _sharedPrefs.setString("user_data", value);
  }

  double get limitsAvailable => _sharedPrefs.getDouble("limits_available") ?? 0;
  set limitsAvailable(double value) {
    _sharedPrefs.setDouble("limits_available", value);
  }

  // static setFcmRegId(String value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("FCM_REG_ID", value);
  // }

  // static Future<String?> getFcmRegId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("FCM_REG_ID") ?? null;
  // }

  // setToken(String value) async {
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _sharedPrefs = await SharedPreferences.getInstance();
  //   _sharedPrefs.setString("api_token", value);
  // }

  // Future<String?> getToken() async {
  //   _sharedPrefs = await SharedPreferences.getInstance();
  //   return _sharedPrefs.getString("api_token") ?? null;
  // }
  // static getToken() async {
  //   final SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? value = pref.getString("api_token");
  //   return value;
  // }

  // static setUser(String value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("user", value);
  // }

  // static Future<String?> getUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("user") ?? null;
  // }
}
