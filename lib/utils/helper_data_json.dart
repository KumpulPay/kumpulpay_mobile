

import 'dart:convert';

import 'package:string_capitalize/string_capitalize.dart';

class HelpersDataJson
{
  static String product(dynamic data, param){
    String output = "";
    if (param == "product_name") {
        if (data["category"] == "PULSA") {            
            output = "${data["category"]} ${data["name_unique"]}";
            output = output.toLowerCase();
            output = output.capitalizeEach();
        }
    }
    return output;
  }
}