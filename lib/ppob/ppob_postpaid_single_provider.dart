import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/repository/sqlite/customer_number_dao.dart';
import 'package:kumpulpay/repository/sqlite/customer_number_entity.dart';
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
  final String? type, typeName, category, categoryName, provider, providerImage;
  final dynamic child;

  const PpobPostpaidSingleProvider({Key? key, this.type, this.typeName, this.category, this.categoryName, this.provider, this.providerImage, this.child}) : super(key: key);

  @override
  State<PpobPostpaidSingleProvider> createState() => _PpobPostpaidSingleProviderState();
}

class _PpobPostpaidSingleProviderState extends State<PpobPostpaidSingleProvider> {

  PpobPostpaidSingleProvider? args;
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();
  final ScrollController scrollController = ScrollController();
  String? title;
  String? _type, _typeName;
  String? _category, _categoryName;
  String? _provider, _providerImage;
  dynamic _productCheck, _productPay;
  String _txtDestination = "";
  bool isButtonEnabled = false;
  bool isLoading = false;
  List<dynamic> dataCustomerNumber = [];
  int currentPage = 1;
  int itemsPerPage = 20; // Tentukan jumlah item per halaman
  CustomerNumberDao? customerNumberDao;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  // Fungsi untuk memuat data
  Future<void> loadData() async {
    if (isLoading) return; // Prevent multiple requests
    setState(() {
      isLoading = true;
    });
    
    final newResults = await customerNumberDao!.getAll(itemsPerPage, currentPage);
    // final newResults = await customerNumberDao!.getAllByCategory('$_type-$_category-$_provider', itemsPerPage, currentPage);
    
    setState(() {
      dataCustomerNumber.addAll(newResults); // Menambahkan data ke list yang sudah ada
      currentPage++; // Increment page
      isLoading = false;
    });
  }

  // Fungsi untuk menangani scroll
  void _scrollListener(ScrollController controller) {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      loadData(); // Load more data when reached the bottom
    }
  }
  
  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();

    WidgetsBinding.instance.addPostFrameCallback((_) {
       args = ModalRoute.of(context)!.settings.arguments as PpobPostpaidSingleProvider?;

        _type = args!.type;
        _typeName = args!.typeName;
        _category = args!.category;
        _categoryName = args!.categoryName;
        _provider = args!.provider;
        _providerImage = args!.providerImage;
       
        final filteredData = filterDataByCode(args!.child);
        _productCheck = filteredData['startsWithC'];
        _productPay = filteredData['startsWithB'];
    });

    customerNumberDao = GetIt.instance.get<CustomerNumberDao>();

    loadData();
    scrollController.addListener(() => _scrollListener(scrollController));
  }
  
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

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
                  physics: const NeverScrollableScrollPhysics(),
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
          backgroundImage: setNetWorkImage(_providerImage),
          radius: 24,
        ),
        const SizedBox(width: 12),
        Text(
          _categoryName??'',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  ImageProvider setNetWorkImage(String? images) {
    if (images == null || images.isEmpty) {
      return AssetImage("images/logo_app/disabled_kumpulpay_logo.png");
    }
    return NetworkImage(images);
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
            padding: const EdgeInsets.symmetric(horizontal:0),
            child: FormBuilderTextFieldCustom.type1(
                notifire.getdarkscolor,
                Colors.grey, //hint color
                notifire.getPrimaryPurpleColor,
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
        const Text(
          "Nomor Terakhir",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: height / 100),
        // Check if dataCustomerNumber is not empty
        if (dataCustomerNumber.isNotEmpty)
          Container(
            height: height / 3, // Adjust height based on your needs
            child: ListView.builder(
              controller: scrollController,
              itemCount: dataCustomerNumber.length +
                  (isLoading ? 1 : 0), // Handle loading state
              itemBuilder: (context, index) {
                // Handle loading state and show list items
                if (index < dataCustomerNumber.length) {
                  CustomerNumberEntity mCustomer = dataCustomerNumber[index];
                  return ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.copy, color: Colors.grey),
                      onPressed: () {
                        // Menyalin customerNumber ke clipboard
                        Clipboard.setData(
                            ClipboardData(text: mCustomer.customerNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Nomor pelanggan disalin!")),
                        );
                      },
                    ),
                    title: Text(
                      mCustomer.customerName ?? "Nomor ID Pelanggan",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          color: notifire.getdarkscolor,
                          fontFamily: 'Gilroy Bold',
                          fontSize: height / 54),
                    ),
                    subtitle: Text(
                      mCustomer
                          .customerNumber, // Access customerNumber directly
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Gilroy Medium',
                          fontSize: height / 55),
                    ),
                    onTap: () {
                      // Action when item is tapped
                    },
                    
                    contentPadding: const EdgeInsets.symmetric(),
                  );
                } else {
                  // Show loading indicator if isLoading is true and it's the last item
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        else
          // Show message when dataCustomerNumber is empty
          Row(
            children: [
              SizedBox(
                width: width / 100,
              ),
              Padding(
                padding: EdgeInsets.all(height / 70),
                child: const Icon(Icons.receipt_long, color: Colors.grey),
              ),
              SizedBox(
                width: width / 100,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 60,
                    ),
                    Text(
                      "Belum ada nomor terakhir",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          color: notifire.getdarkscolor,
                          fontFamily: 'Gilroy Bold',
                          fontSize: height / 54),
                    ),
                    Text(
                      "Transaksi dulu biar ada nomor kamu di sini",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Gilroy Medium',
                          fontSize: height / 55),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isEnabled) {
    return GestureDetector(
      onTap: () {
        isEnabled ? _checkBill() : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Masukkan nomor terlebih dulu!")));
      },
      child: Container(
        height: height / 18,
        width: width,
        decoration: BoxDecoration(
          color: isEnabled
              ? notifire.getPrimaryPurpleColor
              : notifire.getdarkgreycolor, // Mengubah warna saat tombol dinonaktifkan
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          border: Border.all(
              color: isEnabled
                  ? notifire.getPrimaryPurpleColor
                  : notifire.getdarkgreycolor), // Border juga berubah
        ),
        child: Center(
          child: Text(
            "Lanjut ke pembayaran",
            style: TextStyle(
              color: notifire.getwhite, // Ubah warna teks saat dinonaktifkan
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

  Map<String, dynamic> filterDataByCode(List<dynamic> data) {
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
    Loading.showLoadingDialog(context, _globalKey);

    Map<String, dynamic> body = {
      "product_code": _productCheck['code'],
      "destination": _txtDestination,
    };

    final response = await ApiClient(AppConfig().configDio()).postCheckBill(authorization: 'Bearer ${SharedPrefs().token}', body: body);

    Navigator.pop(context);
    try {
      if (response.success) {
        dynamic dataCheck = response.data;

        await _storeNotification(dataCheck);

        // Tampilkan modal setelah operasi async selesai
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
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: response.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      rethrow;
    }
  }

  Future<void> _storeNotification(dynamic formData) async {
    final customerNId = CustomerNumberEntity.optional(
      category: '$_type-$_category-$_provider',
      customerNumber: _txtDestination,
      customerName: formData['bill_details']['customer_name'],
    );
    print('XXXXX ${customerNId.toJson()}');
    try {
      await customerNumberDao!.insertData(customerNId); 
    } catch (e) {
      print('Error _storeNotification: $e');
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
