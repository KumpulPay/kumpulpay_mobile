import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/master/regional_search.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/normaltextfild.dart';
import 'package:kumpulpay/verification/document_data.dart';
import 'package:provider/provider.dart';


class AddressData extends StatefulWidget {
  static String routeName = '/address_data';
  final Map<String, dynamic>? receivedFormData;
  const AddressData({Key? key, this.receivedFormData}) : super(key: key);

  @override
  State<AddressData> createState() => _AddressDataState();
}

class _AddressDataState extends State<AddressData> {
  AddressData? args;
  late ColorNotifire notifire;
  final _formKey = GlobalKey<FormBuilderState>();
  
  late String _codeProvince, _codeCity, _codeDistrict, _codeSubdistrict = '';
  late int _provinceId, _cityId, _districtId, _subdistrictId;
  late TextEditingController _provinceController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _subdistrictController;
  Map<String, dynamic>? _receivedFormData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as AddressData?;
      _receivedFormData = args!.receivedFormData;
    });
    _provinceController = TextEditingController();
    _cityController = TextEditingController();
    _districtController = TextEditingController();
    _subdistrictController = TextEditingController();
  }

  @override
  void dispose() {
    _provinceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _subdistrictController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          'Data Alamat',
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontFamily: 'Gilroy Bold',
              fontSize: height / 40),
        ),
        centerTitle: true,
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
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          SizedBox(height: height / 30),
                          Text(
                            'Data berikut wajib diisi untuk kebutuhan aplikasi.',
                            style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontSize: height / 50,
                              fontFamily: 'Gilroy Medium',
                            ),
                          ),
                          SizedBox(height: height / 30),

                          inputText('Provinsi*',
                              name: 'province',
                              controller: _provinceController,
                              hinttext: 'Pilih Provinsi',
                              suffixIcon: const Icon(Icons.navigate_next),
                              validator: FormBuilderValidators.required(), readOnly: true, onTap: () async {
                                final dynamic selectedItem = await Navigator.pushNamed(context, RegionalSearch.routeName,
                                    arguments: const RegionalSearch(code: ''));
                                if (selectedItem != null) {
                                  setState(() {
                                    _cityController.text = '';
                                    _districtController.text = '';
                                    _subdistrictController.text = '';
                                    _provinceId = selectedItem['id'] ?? '';
                                    _codeProvince = selectedItem['code'] ?? '';
                                    _provinceController.text = selectedItem['name'] ?? '';
                                  });
                                }
                              }),
                          SizedBox(height: height / 40),

                          inputText('Kota/Kab*',
                              name: 'city',
                              controller: _cityController,
                              hinttext: 'Pilih Kota/Kab',
                              suffixIcon: const Icon(Icons.navigate_next),
                              validator: FormBuilderValidators.required(), readOnly: true, onTap: () async {
                               final dynamic selectedItem = await Navigator.pushNamed(context, RegionalSearch.routeName, arguments: RegionalSearch(code: _codeProvince));
                                if (selectedItem != null) {
                                  setState(() {
                                    _districtController.text = '';
                                    _subdistrictController.text = '';
                                    _cityId = selectedItem['id'] ?? '';
                                    _codeCity = selectedItem['code'] ?? '';
                                    _cityController.text = selectedItem['name'] ?? '';
                                  });
                                }
                              }),
                          SizedBox(height: height / 40),

                          inputText('Kecamatan*',
                              name: 'district',
                              controller: _districtController,
                              hinttext: 'Pilih Kecamatan',
                              suffixIcon: const Icon(Icons.navigate_next),
                              validator: FormBuilderValidators.required(), readOnly: true, onTap: () async {
                                final dynamic selectedItem = await Navigator.pushNamed(context, RegionalSearch.routeName, arguments: RegionalSearch(code: _codeCity));
                                if (selectedItem != null) {
                                  setState(() {
                                    _subdistrictController.text = '';
                                    _districtId = selectedItem['id'] ?? '';
                                    _codeDistrict = selectedItem['code'] ?? '';
                                    _districtController.text = selectedItem['name'] ?? '';
                                  });
                                }
                              }),
                          SizedBox(height: height / 40),

                          inputText('Kelurahan*',
                              name: 'subdistrict',
                              controller: _subdistrictController,
                              hinttext: 'Pilih Kelurahan',
                              suffixIcon: const Icon(Icons.navigate_next),
                              validator: FormBuilderValidators.required(), readOnly: true, onTap: () async {
                                final dynamic selectedItem = await Navigator.pushNamed(context, RegionalSearch.routeName, arguments: RegionalSearch(code: _codeDistrict));
                                if (selectedItem != null) {
                                  setState(() {
                                    _subdistrictId = selectedItem['id'] ?? '';
                                    _codeSubdistrict = selectedItem['code'] ?? '';
                                    _subdistrictController.text = selectedItem['name'] ?? '';
                                  });
                                }
                              }),
                          SizedBox(height: height / 40),

                          inputTextArea('Alamat Sesuai Identitas KTP*',
                              name: 'address',
                              hinttext: 'Masukkan Alamat Sesuai KTP',
                              validator: FormBuilderValidators.required()),
                          SizedBox(height: height / 40),

                          inputText('Kode POS*',
                              name: 'postal_code',
                              hinttext: 'Kode POS',
                              readOnly: false,
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Kode Pos wajib diisi!'),
                                FormBuilderValidators.equalLength(5,
                                    errorText: 'Kode Pos harus 5 karakter!'),
                              ])),
                          SizedBox(height: height / 40),


                        ],
                      ),
                    ),
                  ),
                ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: width / 20,
                    right: width / 20,
                    top: height / 80,
                    bottom: height / 60),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: notifire.getPrimaryPurpleColor,
                      // padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState?.value;
                        final newFormData = await _rebuildFormData(formData);
                        print('newFormDataX: $newFormData');
                        Navigator.pushNamed(context, DocumentData.routeName, arguments: DocumentData(receivedFormData: newFormData));
                      } else {
                        print('validation fail');
                      }
                    },
                    child: Text(
                      'Lanjutkan',
                      style: TextStyle(
                        fontSize: height / 50,
                        fontFamily: 'Gilroy Bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      )
    );
  }

  Widget inputText(txtLabel,
      {name, initialValue, hinttext, controller, keyboardType, validator, readOnly, onTap, Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txtLabel,
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 50,
              fontFamily: 'Gilroy Bold'),
        ),
        SizedBox(height: height / 80),
        NormalCustomtextfilds.textField(
            name: name,
            initialValue: initialValue,
            textclr: notifire.getdarkscolor,
            hintclr: notifire.getdarkgreycolor,
            borderclr: notifire.getPrimaryPurpleColor,
            hinttext: hinttext,
            w: 0,
            fillcolor: notifire.gettabwhitecolor,
            context: context,
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            readOnly: readOnly,
            onTap: onTap,
            suffixIcon: suffixIcon
            ),
        // validator: FormBuilderValidators.required()),
      ],
    );
  }

  Widget inputTextArea(txtLabel,
      {name,
      hinttext,
      controller,
      keyboardType,
      validator,
      onTap,
      Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txtLabel,
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 50,
              fontFamily: 'Gilroy Bold'),
        ),
        SizedBox(height: height / 80),
        NormalCustomtextfilds.textField(
            name: name,
            textclr: notifire.getdarkscolor,
            hintclr: notifire.getdarkgreycolor,
            borderclr: notifire.getPrimaryPurpleColor,
            hinttext: hinttext,
            w: 0,
            fillcolor: notifire.gettabwhitecolor,
            context: context,
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            minLines: 3,
            validator: validator,
           ),
        // validator: FormBuilderValidators.required()),
      ],
    );
  }

  Future <dynamic> _rebuildFormData(dynamic formData) async {
    final dynamic addressData = {
      'province_id': _provinceId,
      'city_id': _cityId,
      'district_id': _districtId,
      'subdistrict_id': _subdistrictId,
      'postal_code': formData['postal_code'],
      'address': formData['address'],
    };
    final dynamic newFormData = {
      'personal_data': _receivedFormData,
      'address_data': addressData,
    };
    print('aaa');
    return newFormData;
  }
}