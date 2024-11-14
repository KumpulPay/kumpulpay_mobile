import 'package:flutter/material.dart';
import 'color.dart';

class ColorNotifire with ChangeNotifier {
  bool isDark = false;

  set setIsDark(value) {
    isDark = value;
    notifyListeners();
  }

  get getIsDark => isDark;

  get getprimerycolor => isDark ? darkPrimeryColor : primeryColor;

  get getbackcolor => isDark ? darkbackColor : lightbackColor;

  get getprimerydarkcolor => isDark ? primerydarkColor : primerylightColor;

  get getTitleColor => isDark ? titleLightColor : titleDarkColor;

  get getdarkscolor => isDark ? lightColor : darkColor;

  get getdarkgreycolor => isDark ? darkgreyColor : greyColor;

  get getdarkwhitecolor => isDark ? darkwhiteColor : lightwhiteColor;

  get getbluecolor => isDark ? darkblueColor : blueColor;

  get gettabcolor => isDark ? darktabColor : tabColor;

  get gettabwhitecolor => isDark ? darktabwhiteColor : lighttabwhiteColor;

  get getPrimaryPurpleColor => isDark ? darkPrimaryPurpleColor : primaryPurpleColor;
  get getPrimaryPinkColor => isDark ? darkPrimaryPinkColor : primaryPinkColor;
  get getPrimaryYellowColor => isDark ? darkPrimaryYellowColor : primaryYellowColor;

  get getgreycolor => isDark ? darktabwhiteColor : lighttabwhiteColor;

  get getwhite => isDark ? primerydarkColor : lightColor;
}
