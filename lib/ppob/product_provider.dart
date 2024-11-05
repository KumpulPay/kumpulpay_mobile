
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends StatefulWidget {
  static String routeName = '/ppob/product/provider';
 
  final List<dynamic>? providerList;
  const ProductProvider({Key? key, this.providerList}) : super(key: key);

  @override
  State<ProductProvider> createState() => _ProductProviderState();
}

class _ProductProviderState extends State<ProductProvider> {
  late ColorNotifire notifire;

  ProductProvider? args;
  final _formKey = GlobalKey<FormBuilderState>();
  List<dynamic> providerList = [];
  List<dynamic> filteredProviderList = []; // Daftar hasil filter

  @override
  void initState() {
    super.initState();
    notifire = Provider.of<ColorNotifire>(context, listen: false);
    getdarkmodepreviousstate();

    // Ambil data provider list dari args
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as ProductProvider?;
      providerList = args?.providerList ?? [];
      filteredProviderList = providerList; // Set default hasil filter
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Ambil data provider list dari args
  //   final args = ModalRoute.of(context)!.settings.arguments as ProductProvider?;
  //   providerList = args?.providerList ?? [];
  //   filteredProviderList = providerList; // Set default hasil filter
  // }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  void _filterProviderList(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProviderList = providerList;
      } else {
        filteredProviderList = providerList
            .where((provider) => provider['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    // args = ModalRoute.of(context)!.settings.arguments as ProductProvider?;
    // providerList = args!.providerList ?? [];
    // print('providerX ${args!.provider}');
    print('providerListXX ${providerList}');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          "Pilih Provider",
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilder(
              key: _formKey,
              child: textfeildC("cari_provider", "",
                  hintText: "Cari Provider...",
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                     _filterProviderList(value ?? '');
                  },
                  suffixIconInteractive: GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height / 50, horizontal: height / 70),
                      child: Image.asset(
                        "images/search.png",
                        height: height / 50,
                      ),
                    ),
                  )),
            ),
            // end input destination
          ),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  color: Colors.transparent,
                  child: Image.asset(
                    "images/background.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 50,
                    ),
                    _buildListAction(filteredProviderList),
                    SizedBox(
                      height: height / 50,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListAction(List<dynamic> items) {
    // print('itemsX: ${items.length}');
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 15),
          child: Container(
            color: Colors.transparent,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                // print('itemXX ${items[index]}');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: GestureDetector(
                    onTap: () {
                      // dynamic selectedProvider = items[index]; // Ambil data provider yang dipilih

                      Navigator.pop(context, items[index]); // Kirim data kembali
                    },
                    child: Container(
                      // height: height / 9,
                      width: width,
                      decoration: BoxDecoration(
                        color: notifire.getdarkwhitecolor,
                        // border: Border.all(
                        //   color: Colors.grey.withOpacity(0.2),
                        // ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 20),
                        child: Row(
                          children: [
                            // start icon
                            Container(
                              height: height / 15,
                              width: width / 8,
                              decoration: BoxDecoration(
                                color: notifire.gettabwhitecolor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "images/logo_app/ic_launcher-playstore.png",
                                  height: height / 20,
                                ),
                              ),
                            ),
                            // end icon
                            SizedBox(
                              width: width / 30,
                            ),
                            Text(
                              items[index]['name'],
                              style: TextStyle(
                                  fontFamily: "Gilroy Bold",
                                  color: notifire.getdarkscolor,
                                  fontSize: height / 50),
                            ),
                            const Spacer(),
                            Icon(Icons.arrow_forward_ios,
                                color: notifire.getdarkscolor,
                                size: height / 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
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
            padding: EdgeInsets.symmetric(horizontal: width / 20),
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
}