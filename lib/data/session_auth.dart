

import 'package:kumpulpay/data/shared_prefs.dart';

class SessionAuth {

  static final SessionAuth _instance = SessionAuth._internal();
  factory SessionAuth() => _instance;
  SessionAuth._internal();


  dynamic get sessionAuth => SharedPrefs().userData;
  set sessionAuth(dynamic value) {

  }



}