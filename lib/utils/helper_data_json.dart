import 'package:kumpulpay/utils/helpers.dart';
import 'package:string_capitalize/string_capitalize.dart';

class HelpersDataJson {
  static String product(dynamic data, param) {
    print('dataX ${data}');
    String output = "";
    if (param == "product_name") {
      if ("${data["type"]}-${data["category"]}" == "prepaid-pulsa" || "${data["type"]}-${data["category"]}" == "prepaid-pln_prepaid") {
        var nameUnique = Helpers.shortenNumber(double.parse(data["name_unique"]));
        output = "${data["category_short_name"]} ${nameUnique}";
        output = output.toLowerCase();
        output = output.capitalizeEach();
      }
    }
    print('outputX ${output}');
    return output;
  }
}
