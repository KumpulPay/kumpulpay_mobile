import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/normaltextfild.dart';
import 'package:kumpulpay/verification/address_data.dart';
import 'package:provider/provider.dart';

class PersonalData extends StatefulWidget {
  static String routeName = '/personal_data';
  const PersonalData({Key? key}) : super(key: key);

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: notifire.getdarkscolor),
          elevation: 0,
          backgroundColor: notifire.getprimerycolor,
          title: Text(
            'Data Diri',
            style: TextStyle(
              color: notifire.getdarkscolor,
              fontFamily: 'Gilroy Bold',
              fontSize: height / 40,
            ),
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

                            // Nama Sesuai Identitas KTP
                            inputText('Nama Sesuai Identitas KTP*',
                                name: 'name',
                                hinttext: 'Masukan Nama Sesuai KTP',
                                validator: FormBuilderValidators.required()),
                            SizedBox(height: height / 40),

                            // Nomor Identitas KTP
                            inputText('Nomor Identitas KTP*',
                                name: 'identity_number',
                                hinttext: 'Masukkan Nomor Sesuai KTP',
                                keyboardType: TextInputType.number,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.equalLength(16, errorText: 'Nomor KTP harus tepat 16 karakter!')
                                ])),
                            SizedBox(height: height / 40),

                            // Tempat Lahir
                            inputText('Tempat Lahir*',
                                name: 'place_of_birth',
                                hinttext: 'Masukan Tempat Lahir',
                                validator: FormBuilderValidators.required()),
                            SizedBox(height: height / 40),

                            // Tanggal Lahir
                            inputDate('Tanggal Lahir*',
                                name: 'date_of_birth',
                                hinttext: 'Masukan Tanggal Lahir',
                                validator: FormBuilderValidators.required()),
                            SizedBox(height: height / 40),

                            // Jenis Kelamin
                            FormBuilderRadioGroup<String>(
                              name: 'gender',
                              decoration: InputDecoration(
                                labelText: 'Jenis Kelamin*',
                                labelStyle: TextStyle(
                                    color: notifire.getdarkscolor,
                                    fontSize: height / 40,
                                    fontFamily: 'Gilroy Bold'),
                                border: InputBorder.none,
                              ),
                              validator: FormBuilderValidators.required(),
                              options: const [
                                FormBuilderFieldOption(
                                    value: 'Laki-Laki',
                                    child: Text('Laki-Laki')),
                                FormBuilderFieldOption(
                                    value: 'Perempuan',
                                    child: Text('Perempuan')),
                              ],
                            ),
                            SizedBox(height: height / 60),

                            // Nama Ibu Kandung
                            inputText('Nama Ibu Kandung*',
                                name: 'mother_name',
                                hinttext: 'Masukkan Nama Ibu Kandung',
                                validator: FormBuilderValidators.required()),
                            SizedBox(height: height / 40),

                            // // Email
                            // inputText('Email*',
                            //     name: 'email',
                            //     initialValue: SharedPrefs().userDataObj['email'],
                            //     hinttext: 'Masukkan Email',
                            //     keyboardType: TextInputType.emailAddress,
                            //     validator: FormBuilderValidators.compose([
                            //       FormBuilderValidators.required(),
                            //       FormBuilderValidators.email(),
                            //     ])),
                            // SizedBox(height: height / 40),

                            // // Nomor WhatsApp
                            // inputText('Nomor WhatsApp*',
                            //     name: 'phone',
                            //     initialValue: SharedPrefs().userDataObj['phone'],
                            //     hinttext: 'Masukkan Nomor Whatsapp',
                            //     keyboardType: TextInputType.phone,
                            //     validator: FormBuilderValidators.required()),
                            // SizedBox(height: height / 40),

                            // NPWP (Optional)
                            inputText('NPWP (Optional)',
                                name: 'npwp',
                                hinttext: 'Masukkan Nomor Npwp',
                                keyboardType: TextInputType.number),
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
                        // primary: notifire.getdarkscolor,
                        // padding: EdgeInsets.symmetric(vertical: height / 70 ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          
                          final formData = _formKey.currentState?.value;
                          Navigator.pushNamed(context, AddressData.routeName,
                              arguments: AddressData(receivedFormData: formData));
                          
                          print('Form Data: $formData');
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
            )));
  }

  Widget inputText(
    txtLabel, {
    name,
    initialValue,
    hinttext,
    controller,
    keyboardType,
    validator
  }) {
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
            validator: validator),
            // validator: FormBuilderValidators.required()),
      ],
    );
  }

  Widget inputDate(
    txtLabel, {
    name,
    initialValue,
    hinttext,
    controller,
    keyboardType,
    validator
  }) {
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
          name: 'date_of_birth',
          textclr: notifire.getdarkscolor,
          hintclr: notifire.getdarkgreycolor,
          borderclr: notifire.getPrimaryPurpleColor,
          hinttext: 'Masukkan tanggal lahir',
          w: 0,
          fillcolor: notifire.gettabwhitecolor,
          context: context,
          controller: dateOfBirthController, // Menggunakan controller
          validator: FormBuilderValidators.required(
            errorText: 'Tanggal lahir wajib diisi',
          ),
          readOnly: true,
          suffixIcon: const Icon(Icons.date_range),
          onTap: () async {
            // Menampilkan date picker
            final DateTime? dateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(3000),
            );
            if (dateTime != null) {
              // Format tanggal
              final String formattedDate =
                  "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

              // Memperbarui nilai di controller
              dateOfBirthController.text = formattedDate;

              // Mengupdate nilai di FormBuilder
              FormBuilder.of(context)
                  ?.fields['date_of_birth']
                  ?.didChange(formattedDate);
            }
          },
        ),
      ],
    );
  }

}
