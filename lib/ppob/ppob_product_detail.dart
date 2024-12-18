
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/phone_provider.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/transaction/confirm_pin.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:kumpulpay/verification/personal_data.dart';
import 'package:kumpulpay/verification/verify_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:string_capitalize/string_capitalize.dart';

class PpobProductDetail extends StatefulWidget {
  static String routeName = '/ppob/product/detail';
  final String? type;
  final String? category;
  final dynamic categoryData;
  final dynamic providerData;
  // final String? provider;
  final dynamic txtDestination;
  const PpobProductDetail({Key? key, this.type, this.category, this.categoryData, this.providerData, this.txtDestination}) : super(key: key);

  @override
  State<PpobProductDetail> createState() => _PpobProductDetailState();
}

class _PpobProductDetailState extends State<PpobProductDetail> {

  PpobProductDetail? args;
  late bool _loading = true;  
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();
  late ScrollController _scrollController;
  List<GlobalKey> _sectionKeys = [];
  dynamic _categoryData;
  dynamic _providerData;
  String? _type;
  String? _category;
  String? _filterCategory; 
  String _txtDestination = "";
  String? title;
  Map<String, dynamic> phoneProvider = {};
  String _txtProvider = "";
  List<dynamic> productList = [];
  Map<String, dynamic>? startsWithC;
  dynamic dataCheck;
  bool isVerifiedKyc = false;

  @override
  void initState() {
    super.initState();
     _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as PpobProductDetail?;
      _type = args!.type;
      _category = args!.category;
      _categoryData = args!.categoryData;
      _providerData = args!.providerData;
      _filterCategory = '${_type}-${_category}';
      _txtDestination = _txtDestination.isEmpty ? args!.txtDestination : _txtDestination;
   
      // _txtProvider = args!.providerData['provider'] ?? '';
      _txtProvider = args!.providerData['provider'] ?? '';

      if (_filterCategory != 'prepaid-e_money') {
        if (_txtDestination.isNotEmpty) {
          phoneProvider = PhoneProvider.getProvide(_txtDestination);
          _txtProvider = phoneProvider['provider'];
        }
      }
      print('_categoryDataXX ${_categoryData}');
      print('_providerDataXX ${_providerData}');
      title = '${_categoryData['name']} ${_providerData['provider_name']}';

      if (_filterCategory == 'prepaid-pulsa' ||
          _filterCategory == 'prepaid-e_money') {
        productList = List.filled(6, {
          "name_unique": "5000",
          "price_fixed": 0,
        });
      } else {
        productList = List.filled(6, {
          "name_unique": "BSMART",
          "price_fixed": 0,
        });
      }

      _fetchData();
    }); 
      
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  void _scrollToSection(int index) {
    if (index >= _sectionKeys.length) {
      print('Index $index di luar jangkauan _sectionKeys');
      return;
    }
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyContext = _sectionKeys[index]?.currentContext;
      print('keyContextX $keyContext');
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        print('keyContext masih null untuk index $index');
      }
    });
  }

  void handleFormSubmission(String value) {
    // print('Text submitted: $value');
 
    // setState(() {
    //   _txtDestination = value;
    //   if (_type == 'pulsa' ||
    //       _type == 'data' ||
    //       _type == 'paket_sms' ||
    //       _type == 'paket_telepon') {
    //     phoneProvider = PhoneProvider.getProvide(value);
    //     print('phoneProvider: ${phoneProvider}');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Skeletonizer(
          enabled: _loading,
          child: Text(
              "${title?.capitalizeEach()}",
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontSize: height / 40,
                  fontFamily: 'Gilroy Bold'),
            )
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
              70), // Set preferred height of the TextField
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Skeletonizer(
              enabled: _loading,
              child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: textfeildC("input_nomor", "",
                      hintText: "Masukkan nomor...",
                      initialValue: _txtDestination,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(9),
                      ]), onSubmitted: (value) {
                        if (_formKey.currentState?.validate() ?? false) {
                          _txtDestination = value;
                        } else {
                          print('Form tidak valid!');
                        }
                      }, onChanged: (value) {
                        if (_formKey.currentState?.validate() ?? false) {
                          _txtDestination = value;
                        }
                      },
                      suffixIconInteractive: GestureDetector(
                        onTap: () {
                          // _toggle();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height / 50, horizontal: height / 70),
                          child: Image.asset(
                            "images/ic_contact.png",
                            height: height / 50,
                          ),
                        ),
                      )),
                )
            ),
          ),
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
                  // controller: _scrollController,
                  child: Column(
                    children: [
                      
                      _buildList(),

                      SizedBox(
                        height: height / 50,
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
      ),
    );
  }

  Widget textfeildC(name, labelText_,
      {hintText,
      labelText,
      initialValue,
      prefixIcon,
      suffixIconInteractive,
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
            padding: EdgeInsets.symmetric(horizontal: width / 40),
            child: FormBuilderTextFieldCustom.type1(
                notifire.getdarkscolor,
                Colors.grey, //hint color
                notifire.getPrimaryPurpleColor,
                notifire.getdarkwhitecolor,
                hintText: hintText,
                prefixIcon: prefixIcon,
                name: name,
                initialValue: initialValue,
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

  void _fetchData() async {
    try {
      final Map<String, dynamic> queries = {
        "type": _type,
        "category": _category,
        "provider": _txtProvider
      };
    
      final response = await ApiClient(AppConfig().configDio(context: context)).getProduct(authorization: 'Bearer ${SharedPrefs().token}', queries: queries);

      if (response.success) {
        setState(() {
          if (_filterCategory == 'prepaid-pulsa' || _filterCategory == 'prepaid-e_money') {
            final List<dynamic> data = response.data;

            // Filter data where code starts with "C" (case-insensitive)
            startsWithC = data.firstWhere(
              (item) {
                String code = item['code'] ?? '';
                return code.toLowerCase().startsWith('c');
              },
              orElse: () => null,
            );

            // Filter data where code does not start with "C"
            final List<dynamic> doesNotStartWithC = data.where((item) {
              String code = item['code'] ?? '';
              return !code.toLowerCase().startsWith('c');
            }).toList();

            productList = doesNotStartWithC;

            _loading = false;
          } else if (_filterCategory == 'entertainment-game') {
            final List<dynamic> data = response.data;

            startsWithC = data.firstWhere(
              (item) {
                return item['price'] == 0;
              },
              orElse: () => null,
            );

            final List<dynamic> doesNotStartWithC = data.where((item) {
              return item['price'] > 0;
            }).toList();

            productList = doesNotStartWithC;

            _loading = false;
          } else {
            productList =
                groupDataByTypeCategoryProviderPaketData(response.data);
            _loading = false;
          }
        });
      } else {
        setState(() {
          productList = [];
        });
      }
    } catch (e) {
      setState(() {
        productList = [];
      });
    }
  }
  
  Widget _buildList(){
    if (_filterCategory == 'prepaid-pulsa' ||
        _filterCategory == 'prepaid-e_money') {
      return _buildItemGridView(productList);

    } else if (_filterCategory == 'entertainment-game') {
      return _buildListLandscape();

    } else {
      _sectionKeys = List.generate(productList.length, (index) => GlobalKey());
      return _buildItemAccordionData(productList);

    }
   
  }

  Widget _buildItemGridView(List<dynamic> listDetail) {
    return Skeletonizer(
      enabled: _loading,
      child: Container(
            color: Colors.transparent,
            width: width,
            child: Builder(builder: (context) {
              return Column(
                children: [
                   SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width / 20, vertical: height / 80),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columns
                                crossAxisSpacing:
                                    10.0, // Spacing between columns
                                mainAxisSpacing: 10.0, // Spacing between rows
                                childAspectRatio: 2.0),
                        itemCount: listDetail.length,
                        itemBuilder: (BuildContext ctxObs, index) {
            
                          double priceList = listDetail[index]["price"].toDouble() +
                              listDetail[index]["margin"].toDouble() -
                              listDetail[index]["discount"].toDouble();
                            
                          return GestureDetector(
                            onTap: () async {
                              if (_filterCategory == 'prepaid-pulsa'){
                                if (int.parse(
                                        listDetail[index]["name_unique"]) > 200000) {
                                  if (!isVerifiedKyc) {
                                    Helpers.showMbsAlertWithAction(context: context, title: 'Akun belum terverifikasi!', subtitle: 'Yuk, segera verifikasi dan lengkapi data kamu sekarang!', txtConfirmButton: 'Lengkapi Data', onConfirm: (){
                                      Navigator.pushNamed(context, VerifyInfo.routeName);
                                    });
                                    return;
                                  }
                                
                                }
                              }
                              if (_txtDestination.isNotEmpty) {
                                if (_filterCategory == 'prepaid-pulsa') {
                                  _openBottomSheet(ctxObs, listDetail, index);
                                } else {
                                  await _checkBill(ctxObs, listDetail, index);
                                }

                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Masukkan nomor terlebih dulu!")));
                              }
                            },
                            child: Container(
                                // width: double.infinity,
                                decoration: BoxDecoration(
                                  color: notifire.gettabwhitecolor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Helpers.currencyFormatter(
                                            double.parse(listDetail[index]
                                                ["name_unique"]),
                                            symbol: ""),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: height / 30,
                                            fontFamily: 'Gilroy Light'),
                                      ),
                                      SizedBox(
                                        height: height / 80,
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                              flex: 1, child: Text("Harga")),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                Helpers.currencyFormatter(priceList),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: notifire
                                                        .getPrimaryPurpleColor,
                                                    fontSize: height / 60,
                                                    fontFamily: 'Gilroy Bold'),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                  )
                ],
              );
            }))
    );
  }

  Widget _buildItemAccordionData(List<dynamic> group1) {

    return Skeletonizer(
      enabled: _loading,
      child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 40),
                child: Accordion(
                    disableScrolling: true,
                    flipRightIconIfOpen: true,
                    contentVerticalPadding: 0,
                    contentBorderColor: Colors.transparent,
                    scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                    maxOpenSections: 1,
                    headerBackgroundColor: notifire.getdarkwhitecolor,
                    headerPadding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    children: [
                     
                      for (var i = 0; i < group1.length; i++) ...[
                        AccordionSection(
                            key: _sectionKeys[i] = GlobalKey(),
                            header: Text(
                              group1[i]["name"],
                              style: TextStyle(
                                  fontFamily: "Gilroy Bold",
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 55),
                            ),
                            onOpenSection: () {
                              _scrollToSection(i);
                            },
                            contentHorizontalPadding: 20,
                            content: Builder(builder: (context) {
                              List<dynamic> group2 = group1[i]["child"];

                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: group2.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (_txtDestination.isNotEmpty) {
                                              _openBottomSheet(
                                                  context, group2, index);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Masukkan nomor terlebih dulu!")));
                                            }
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              // color: notifire.getdarkwhitecolor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width / 30,
                                                  vertical: height / 80),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(group2[index]["name"],
                                                      // maxLines: 3,
                                                      // overflow: TextOverflow
                                                      //     .ellipsis,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Gilroy Medium",
                                                          color: notifire
                                                              .getdarkgreycolor,
                                                          // .withOpacity(0.6),
                                                          fontSize:
                                                              height / 50)),
                                                  SizedBox(height: height / 50),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Harga",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Gilroy Medium",
                                                          fontSize: height / 50,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                          Helpers.currencyFormatter(
                                                              group2[index][
                                                                      "price_fixed"]
                                                                  .toDouble()),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Gilroy Bold",
                                                              color: notifire
                                                                  .getPrimaryPurpleColor,
                                                              fontSize:
                                                                  height / 50)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (index < group2.length -1)
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(),
                                            child: Divider(
                                              color: notifire.getdarkgreycolor
                                                  .withOpacity(0.1),
                                            ),
                                          ),
                                      ],
                                    );
                                  });
                            }))
                      ]
                    ]))
          ],
        )
    );
  }

  Widget _buildListLandscape() {
    return Skeletonizer(
      enabled: _loading,
      child:  Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 40),
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (_txtDestination.isNotEmpty) {
                        
                          startsWithC != null ? await _checkBill(context, productList, index) : _openBottomSheet(context, productList, index);
                         
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Masukkan nomor terlebih dulu!")));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: notifire.getdarkwhitecolor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                                color: Colors.grey.withOpacity(
                                    0.2), // Warna border dengan transparansi
                                // width: 0.5, // Ketebalan border
                              ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 30, vertical: height / 80),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productList[index]["name"],
                                  // maxLines: 3,
                                  // overflow: TextOverflow
                                  //     .ellipsis,
                                  style: TextStyle(
                                      fontFamily: "Gilroy Medium",
                                      color: notifire.getdarkgreycolor,
                                      // .withOpacity(0.6),
                                      fontSize: height / 50)),
                              SizedBox(height: height / 50),
                              Row(
                                children: [
                                  Text(
                                    "Harga",
                                    style: TextStyle(
                                      fontFamily: "Gilroy Medium",
                                      fontSize: height / 50,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                      Helpers.currencyFormatter(
                                          productList[index]["price_fixed"]
                                              .toDouble()),
                                      style: TextStyle(
                                          fontFamily: "Gilroy Bold",
                                          color: notifire.getPrimaryPurpleColor,
                                          fontSize: height / 50)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (index < productList.length - 1)
                     SizedBox(height: height / 60)
                  ],
                );
              })
        ],
      ),
    )
    );
  }

  void _openBottomSheet(
      BuildContext ctxObs, List<dynamic> listDetail, int index) {
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
        context: ctxObs,
        builder: (BuildContext ctxSbs) {
          return _bottomSheetContent(ctxSbs, listDetail, index);
        });
  }

  Widget _bottomSheetContent(BuildContext ctxBsc, List<dynamic> listDetail, int index) {
    // saldo sebelum
    double currentBalance = SharedPrefs().balanceAvailable;

    // saldo setelah
    double remainingBalance = currentBalance - listDetail[index]["price_fixed"].toDouble();
    if (_filterCategory == 'prepaid-e_money') {
      remainingBalance = dataCheck['user_detail']['balance'].toDouble() -
          listDetail[index]["price_fixed"].toDouble();

      currentBalance = dataCheck['user_detail']['balance'].toDouble();    
    }    

    String productCode = listDetail[index]["name_unique"];
    if (_filterCategory == 'prepaid-pulsa' ||
          _filterCategory == 'prepaid-e_money') {
            productCode = Helpers.currencyFormatter(
                    double.parse(productCode),
                    symbol: "");
    }
    
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
                "Nomor Tujuan",
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
        // start customer name
        if (_filterCategory == 'prepaid-e_money') customerName(),
        // end customer name
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                'Produk ${title?.capitalizeEach()}',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                productCode,
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // description
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Deskripsi',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Gilroy Medium',
                    fontSize: height / 60,
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        listDetail[index]["provider"],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: notifire.getdarkscolor,
                          fontFamily: 'Gilroy Medium',
                          fontSize: height / 60,
                        ),
                      ),
                      Text(
                        listDetail[index]["name"],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: notifire.getdarkgreycolor,
                          fontFamily: 'Gilroy Medium',
                          fontSize: height / 60,
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
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
                "Harga",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                    listDetail[index]["price"].toDouble() +
                        listDetail[index]["margin"].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),

        // Start Discount
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Diskon",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                "-${Helpers.currencyFormatter(listDetail[index]["discount"].toDouble())}",
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // End Discount

        // Start Admin
        SizedBox(
          height: height / 80,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: Row(
            children: [
              Text(
                "Biaya Layanan",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.currencyFormatter(
                    listDetail[index]["admin_fee"].toDouble()),
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
        // End Admin

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
                Helpers.currencyFormatter(listDetail[index]["price_fixed"].toDouble()),
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
              "Informasi Deposit",
              style: TextStyle(
                color: notifire.getdarkscolor,
                fontFamily: 'Gilroy Bold',
                fontSize: height / 50,
              ),
            ),
          ],
        ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Helpers.currencyFormatter(
                        currentBalance),
                    style: TextStyle(
                      color: notifire.getdarkscolor,
                      fontFamily: 'Gilroy Medium',
                      fontSize: height / 60,
                    ),
                  ),
                  if (remainingBalance < 0)
                    Text(
                      "Kurang ${Helpers.currencyFormatter(remainingBalance)}",
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Gilroy Medium',
                        fontSize: height / 60,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // end costumer info

        // start action button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 30),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(ctxBsc);
                  },
                  child: Custombutton.button2(notifire.getbackcolor, "Ubah",
                      notifire.getPrimaryPurpleColor),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: width / 50)),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    if (remainingBalance < 0) {
                      Helpers.showMbsAlert(context: context, title: 'Gagal!', 
                      subtitle: 'Saldo kamu saat ini ${Helpers.currencyFormatter(currentBalance)} tidak cukup untuk melakukan transaksi senilai ${Helpers.currencyFormatter(listDetail[index]['price_fixed'].toDouble())}',
                      typeAlert: 'info');
                    } else {
                      await fetchDataAndNavigate(listDetail[index]);
                    }
                  },
                  child: Custombutton.button2(
                      notifire.getPrimaryPurpleColor, "Konfirmasi", Colors.white),
                ),
              ),
            ],
          ),
        ),
        // end action button
      ],
    );
  }

  Future<void> fetchDataAndNavigate(dynamic productSelected) async {
    Loading.showLoadingLogoDialog(context, _globalKey);
    try {
      Map<String, dynamic>? formData = await _generateFormData(productSelected);
      Navigator.pop(context);
      Navigator.pushNamed(context, ConfirmPin.routeName,
          arguments: ConfirmPin(formData: formData));

    } catch (e) {
      print('fetchDataAndNavigate ${e.toString()}');
      Navigator.pop(context);
    }
  }

  Future<Map<String, dynamic>> _generateFormData(
      dynamic productSelected) async {
    await Future.delayed(const Duration(seconds: 1));

    // Validasi _txtDestination
    if (_txtDestination == null) {
      throw Exception('_txtDestination is null');
    }

    // Validasi kunci productSelected
    if (productSelected['price'] == null ||
        productSelected['margin'] == null ||
        productSelected['discount'] == null ||
        productSelected['admin_fee'] == null ||
        productSelected['price_fixed'] == null) {
      throw Exception('Missing keys in productSelected: $productSelected');
    }

    Map<String, dynamic> orderDetail = {
      "destination": _txtDestination,
      "price": productSelected['price'],
      "margin": productSelected['margin'],
      "discount": productSelected['discount'],
      "admin_fee": productSelected['admin_fee'],
      "price_fixed": productSelected['price_fixed']
    };

    Map<String, dynamic> transactionData = {
      "transaction_type": "purchase",
      "payment_method": "deposit",
      "order_detail": orderDetail,
      "product_meta": productSelected,
    };

    return transactionData;
  }

  List<dynamic> groupDataByTypeCategoryProviderPaketData(
      List<dynamic> data) {
    Map<String, List<Map<String, dynamic>>> tempGroupedData = {};

    for (var item in data) {
     
      var splitDescription = item["description"].split(" | "); 
      String groupKey =
          '${item["type"]}_${item["category"]}_${splitDescription[0].trim()}';

      // Jika group key belum ada di dalam tempGroupedData, tambahkan dengan list kosong
      if (!tempGroupedData.containsKey(groupKey)) {
        tempGroupedData[groupKey] = [];
      }

      // Tambahkan item ke list pada group key yang sesuai
      tempGroupedData[groupKey]!.add(item);
    }

    // Konversi tempGroupedData menjadi list sesuai dengan format yang diminta
    List<Map<String, dynamic>> groupedDataArray =
        tempGroupedData.entries.map((entry) {
      
      var splitDesc = entry.value.isNotEmpty ? entry.value[0]["description"].split(" | ") : ""; 
      var provider =entry.value[0]["provider"]; 

      String providerName = splitDesc[0];
      String name = providerName
      .replaceAll(RegExp('${provider} Data', caseSensitive: false), '')
      .replaceAll(RegExp('Data ${provider}', caseSensitive: false), '')
      .replaceAll(RegExp('${provider} Paket', caseSensitive: false), '')
      .replaceAll(RegExp('${provider}', caseSensitive: false), '');
      
      // print('nameX ${provider}');
      return {
        "group_key": entry.key,
        "name": name.trim(),
        "child": entry.value,
      };
    }).toList();
    // print('groupedDataArrayX ${jsonEncode(groupedDataArray)}');
    return groupedDataArray;
  }

  Future<dynamic> _checkBill(
      BuildContext ctxObs, List<dynamic> listDetail, int index) async {

    Loading.showLoadingLogoDialog(context, _globalKey);

    try {
      Map<String, dynamic> body = {
        "product_code": startsWithC!['code'],
        "destination": _txtDestination,
        "type_category_provider": startsWithC!['type_category_provider'],
      };
      
      final response = await ApiClient(AppConfig().configDio(context: context)).postCheckBill(
        authorization:  'Bearer ${SharedPrefs().token}', body: body);  

      Navigator.pop(context);

      if (response.success) {
        setState(() {
          dataCheck = response.data;
        });
        _openBottomSheet(ctxObs, listDetail, index);
      } else {
        Helpers.showMbsAlert(context: ctxObs, title: 'Gagal', subtitle: response.message, typeAlert: 'info');
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      rethrow;
    }
  }

  Widget customerName(){
    return Column(
      children: [
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
                  color: notifire.getdarkgreycolor,
                  fontFamily: 'Gilroy Medium',
                  fontSize: height / 60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}