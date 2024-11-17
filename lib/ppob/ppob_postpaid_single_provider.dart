import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/transaction/confirm_pin.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_capitalize/string_capitalize.dart';

class PpobPostpaidSingleProvider extends StatefulWidget {
  static String routeName = '/ppob/product_single_provider/index';
  final String? type, typeName, category, categoryName;
  final dynamic child;

  const PpobPostpaidSingleProvider({Key? key, this.type, this.typeName, this.category, this.categoryName, this.child}) : super(key: key);

  @override
  State<PpobPostpaidSingleProvider> createState() => _PpobPostpaidSingleProviderState();
}

class _PpobPostpaidSingleProviderState extends State<PpobPostpaidSingleProvider> {
  PpobPostpaidSingleProvider? args;
  final _globalKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();
  late ColorNotifire notifire;
  String? title;
  String? _type, _typeName;
  String? _category, _categoryName;
  String? _provider;
  dynamic _productCheck, _productPay;
  String _txtDestination = "";
  bool isButtonEnabled = false;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }
  
  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    args = ModalRoute.of(context)!.settings.arguments as PpobPostpaidSingleProvider?;

    _type = args!.type;
    _typeName = args!.typeName;
    _category = args!.category;
    _categoryName = args!.categoryName;
    final filteredData = filterDataByCode(args!.child);
    _productCheck = filteredData['startsWithC'];
    _productPay = filteredData['startsWithB'];
    print('Data starts with C: ${filteredData['startsWithC']}');
    print('Data starts with B: ${filteredData['startsWithB']}');
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          _typeName ?? '',
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(
              "images/background.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProviderSection(),
                        SizedBox(height: height / 20),
                        _buildCustomerNumberField(),
                        SizedBox(height: height / 20),
                        _buildPromoSection(),
                        SizedBox(height: height / 20),
                        _buildLastNumberSection(),
                      ],
                    ),
                  ),
                ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildSubmitButton(isButtonEnabled),
              ),
          ],
        )
      ),
      
    );
  }

  Widget _buildProviderSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage:
              AssetImage('assets/indovision_logo.png'),
          radius: 24,
        ),
        SizedBox(width: 12),
        Text(
          _categoryName??'',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCustomerNumberField() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: textfeildC("input_nomor", "",
          hintText: "Masukkan nomor...",
          // enabled: _enabledInput,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          // maxLength: 15,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(9),
          ]),
          onSubmitted: (value) {
            if (_formKey.currentState?.validate() ?? false) {
              // final formValue = _formKey.currentState?.fields['input_nomor']?.value;
              setState(() {
                isButtonEnabled = true;
                _txtDestination = value;
              });
             
            } else {
              print('Form tidak valid!');
              setState(() {
                isButtonEnabled = false;
                _txtDestination = '';
              });
            }
          },
          onChanged: (value) {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() {
                isButtonEnabled = true;
                _txtDestination = value;
              });
            } else {
              print('Form tidak valid!');
              setState(() {
                isButtonEnabled = false;
                _txtDestination = '';
              });
            }
          },
          suffixIconInteractive: GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height / 50, horizontal: height / 70),
              child: Image.asset(
                "images/ic_contact.png",
                height: height / 50,
              ),
            ),
          )),
    );
  }

  Widget textfeildC(name, labelText_,
      {hintText,
      labelText,
      prefixIcon,
      suffixIconInteractive,
      enabled,
      keyboardType,
      textInputAction,
      suffixIcon,
      validator,
      onSubmitted,
      onChanged,
      maxLength}) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal:0),
            child: FormBuilderTextFieldCustom.type1(
                notifire.getdarkscolor,
                Colors.grey, //hint color
                notifire.getbluecolor,
                notifire.getdarkwhitecolor,
                hintText: hintText,
                prefixIcon: prefixIcon,
                name: name,
                enabled: enabled,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                labelText: labelText,
                // suffixIcon: suffixIcon,
                suffixIconInteractive: suffixIconInteractive,
                maxLength: maxLength,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                validator: validator ?? FormBuilderValidators.required()))
      ],
    );
  }

  Widget _buildPromoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dapat 1 Token Main Catchback",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
          SizedBox(height: 4),
          Text("Berlaku s.d. 31 Desember 2024"),
          SizedBox(height: 4),
          Text("Min. penggunaan Saldo OVO Rp10.000"),
        ],
      ),
    );
  }

  Widget _buildLastNumberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nomor Terakhir",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.receipt_long, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              "Belum ada nomor terakhir",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text("Transaksi dulu biar ada nomor kamu di sini"),
      ],
    );
  }

  Widget _buildSubmitButton(bool isEnabled) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              _checkBill();
            }
          : null, // Tidak ada aksi ketika tombol dinonaktifkan
      child: Container(
        height: height / 18,
        width: width,
        decoration: BoxDecoration(
          color: isEnabled
              ? notifire.getbluecolor
              : Colors.grey, // Mengubah warna saat tombol dinonaktifkan
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          border: Border.all(
              color: isEnabled
                  ? notifire.getbluecolor
                  : Colors.grey), // Border juga berubah
        ),
        child: Center(
          child: Text(
            "Lanjut ke pembayaran",
            style: TextStyle(
              color: isEnabled
                  ? Colors.white
                  : Colors.black45, // Ubah warna teks saat dinonaktifkan
              fontSize: height / 55,
              fontFamily: 'Gilroy Bold',
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomSheetContent(BuildContext ctxBsc, dynamic dataCheck) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // start costumer info
        SizedBox(
          height: height / 30,
        ),
        Row(
          children: [
            SizedBox(
              width: width / 20,
            ),
            Text(
              "Informasi Pembelian",
              style: TextStyle(
                color: notifire.getdarkscolor,
                fontFamily: 'Gilroy Bold',
                fontSize: height / 50,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height / 60,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Nomor ID Pelanggan",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                _txtDestination,
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // start product
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                'Nama Pelanggan',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                dataCheck['bill_details']['customer_name'],
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // end product

        // start description
        // SizedBox(
        //   height: height / 80,
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: width / 20),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Expanded(
        //         flex: 1,
        //         child: Text(
        //           'Deskripsi',
        //           style: TextStyle(
        //             color: Colors.grey,
        //             fontFamily: 'Gilroy Medium',
        //             fontSize: height / 60,
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         flex: 2,
        //         child: Text(
        //           "cc",
        //           // listDetail[index]["name"],
        //           textAlign: TextAlign.right,
        //           style: TextStyle(
        //             color: notifire.getdarkgreycolor,
        //             fontFamily: 'Gilroy Medium',
        //             fontSize: height / 60,
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //           flex: 2,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             children: [
        //               Text(
        //                 listDetail[index]["provider"],
        //                 textAlign: TextAlign.right,
        //                 style: TextStyle(
        //                   color: notifire.getdarkscolor,
        //                   fontFamily: 'Gilroy Medium',
        //                   fontSize: height / 60,
        //                 ),
        //               ),
        //               Text(
        //                 listDetail[index]["name"],
        //                 textAlign: TextAlign.right,
        //                 style: TextStyle(
        //                   color: notifire.getdarkgreycolor,
        //                   fontFamily: 'Gilroy Medium',
        //                   fontSize: height / 60,
        //                 ),
        //               ),
        //             ],
        //           ))
        //     ],
        //   ),
        // ),
        // end description
        // end costumer info

        // start payment detail
        SizedBox(
          height: height / 60,
        ),
        Row(
          children: [
            SizedBox(
              width: width / 20,
            ),
            Text(
              "Detail Pembayaran",
              style: TextStyle(
                color: notifire.getdarkscolor,
                fontFamily: 'Gilroy Bold',
                fontSize: height / 50,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height / 60,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Jumlah Tagihan",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                    dataCheck['bill_details']['bill_amount'].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Admin",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                    dataCheck['bill_details']['admin_fee'].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(
              vertical: width / 20, horizontal: width / 20),
          child: const DottedLine(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
            Text(
                "Total Bayar",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                    dataCheck['bill_details']['total'].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // end payment detail

        // start balance info
        SizedBox(
          height: height / 30,
        ),
        Row(
          children: [
            SizedBox(
              width: width / 20,
            ),
            Text(
              "Informasi Saldo",
              style: TextStyle(
                color: notifire.getdarkscolor,
                fontFamily: 'Gilroy Bold',
                fontSize: height / 50,
              ),
            ),
          ],
        ),

        // start deposit
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Deposit",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                    dataCheck['user_detail']['balance'].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // end costumer info

        // start action button
        SizedBox(
          height: height / 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(ctxBsc);
                  },
                  child: Custombutton.button2(notifire.getbackcolor, "Ubah",
                      notifire.getdarkscolor),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: width / 50)),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    _payBill(ctxBsc, _productPay);
                  },
                  child: Custombutton.button2(
                      notifire.getPrimaryPurpleColor, "Konfirmasi", Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height / 20,
        ),
        // end action button
      ],
    );
  }

  Map<String, dynamic> filterDataByCode(List<Map<String, dynamic>> data) {
    final filteredData = {
      'startsWithC': <Map<String, dynamic>>[],
      'startsWithB': <Map<String, dynamic>>[],
    };

    for (var item in data) {
      final code = item['code']?.toString().toLowerCase() ?? '';
      if (code.startsWith('c')) {
        filteredData['startsWithC']!.add(item);
      } else if (code.startsWith('b')) {
        filteredData['startsWithB']!.add(item);
      }
    }

    return filteredData.map(
        (key, value) => MapEntry(key, value.isNotEmpty ? value.first : null));
  }

  Future<dynamic> _checkBill() async {
    try {
      Loading.showLoadingDialog(context, _globalKey);
      Map<String, dynamic> body = {
        "product_code": _productCheck['code'],
        "destination": _txtDestination,
      };
      final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
      final dynamic post = await client.postCheckBill(
          'Bearer ${SharedPrefs().token}', jsonEncode(body));
      
      Navigator.pop(context);
      if (post["status"]) {
        dynamic dataCheck = post['data'];
        
        showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            backgroundColor: notifire.getprimerycolor,
            context: context,
            builder: (context) {
              return _bottomSheetContent(context, dataCheck);
            });
        
      } else {
        Fluttertoast.showToast(
            msg: post["message"],
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16);
      }    
      
    } on DioException catch (e) {
      Navigator.pop(context);
      if (e.response != null) {
        // print(e.response?.data);
        // print(e.response?.headers);
        // print(e.response?.requestOptions);
        bool status = e.response?.data["status"];
        if (status) {
          // return Center(child: Text('Upst...'));
          return e.response;
        }
      } else {
        // print(e.requestOptions);
        // print(e.message);
      }
      rethrow;
    }
  }

  Future<void> _payBill(
      BuildContext context, dynamic productSelected) async {
    Map<String, dynamic> formData = await _generateDataPayBill(productSelected);

    Navigator.pushNamed(context, ConfirmPin.routeName,
        arguments: ConfirmPin(formData: formData));
  }

  Future<Map<String, dynamic>> _generateDataPayBill(
      dynamic productSelected) async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> userData = json.decode(SharedPrefs().userData);
    Map<String, dynamic> customerMeta = {
      "user_id": userData["id"],
      "code": userData["code"],
      "name": userData["name"],
      "phone": userData["phone"],
      "email": userData["email"]
    };

    Map<String, dynamic> transactionData = {
      "payment_method": "deposit",
      "destination": _txtDestination,
      "product_meta": productSelected,
      "customer_meta": customerMeta,
    };

    return transactionData;
  }
}
