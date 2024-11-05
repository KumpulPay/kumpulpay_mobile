import 'package:card_slider/card_slider.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kumpulpay/utils/color.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:kumpulpay/wallet/wallets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late ColorNotifire notifire;

  List<Color> valuesDataColors = [blueColor, const Color(0xff8978fa)];

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  List bankname = [
    "Citibank",
    "Bank of America",
    "usbank",
    "Barclays Bank",
    "HSBC India",
    "Deutsche Bank",
    "DBS Bank"
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    List<Widget> valuesWidget = [];
    for (int i = 0; i < valuesDataColors.length; i++) {
      valuesWidget.add(GestureDetector(
        onTap: () {
          setState(() {
            
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Wallets(),
            ),
          );
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: valuesDataColors[i],
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
            )),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          "Title",
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
        
      ),
      backgroundColor: notifire.getprimerycolor,
      body:CardSlider(
        cards: valuesWidget,
        bottomOffset: .0005,
        cardHeight: 0.75,
        itemDotOffset: 0.25,
      )

      // const Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: const <Widget>[
      //       Text(
      //         'Push the buttons below to create new notifications',
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(20.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const SizedBox(width: 20),
      //       FloatingActionButton(
      //         heroTag: '1',
      //         onPressed: () => NotificationController.createNewNotification(context),
      //         tooltip: 'Create New notification',
      //         child: const Icon(Icons.outgoing_mail),
      //       ),
      //       const SizedBox(width: 10),
      //       FloatingActionButton(
      //         heroTag: '2',
      //         onPressed: () => NotificationController.scheduleNewNotification(context),
      //         tooltip: 'Schedule New notification',
      //         child: const Icon(Icons.access_time_outlined),
      //       ),
      //       const SizedBox(width: 10),
      //       FloatingActionButton(
      //         heroTag: '3',
      //         onPressed: () => NotificationController.resetBadgeCounter(),
      //         tooltip: 'Reset badge counter',
      //         child: const Icon(Icons.exposure_zero),
      //       ),
      //       const SizedBox(width: 10),
      //       FloatingActionButton(
      //         heroTag: '4',
      //         onPressed: () => NotificationController.cancelNotifications(),
      //         tooltip: 'Cancel all notifications',
      //         child: const Icon(Icons.delete_forever),
      //       ),
      //     ],
      //   ),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget textfeildC(name, labelText_,
      {hintText,
      labelText,
      prefixIcon,
      suffixIconInteractive,
      keyboardType,
      textInputAction,
      suffixIcon,
      validator,
      onSubmitted,
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
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                labelText: labelText,
                // suffixIcon: suffixIcon,
                suffixIconInteractive: suffixIconInteractive,
                maxLength: maxLength,
                onSubmitted: onSubmitted,
                validator: validator ?? FormBuilderValidators.required()))
      ],
    );
  }
}
