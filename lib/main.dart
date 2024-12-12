import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kumpulpay/bottombar/bottombar.dart';
import 'package:kumpulpay/category/category.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/home/home.dart';
import 'package:kumpulpay/login/login.dart';
import 'package:kumpulpay/login/register.dart';
import 'package:kumpulpay/login/setupprofile.dart';
import 'package:kumpulpay/login/confirmpin.dart' as cplogin;
import 'package:kumpulpay/login/setyourpin.dart';
import 'package:kumpulpay/login/verify.dart';
import 'package:kumpulpay/master/regional_search.dart';

import 'package:kumpulpay/notification/notification_list.dart';
import 'package:kumpulpay/onbonding.dart';
import 'package:kumpulpay/ppob/ppob_postpaid_single_provider.dart';
import 'package:kumpulpay/ppob/ppob_postpaid.dart';
import 'package:kumpulpay/ppob/ppob_product.dart';
import 'package:kumpulpay/ppob/ppob_product_detail.dart';
import 'package:kumpulpay/ppob/product_provider.dart';
import 'package:kumpulpay/profile/editprofile.dart';
import 'package:kumpulpay/repository/camera/camera_frame_screen.dart';
import 'package:kumpulpay/repository/notification/notification_controller.dart';
import 'package:kumpulpay/repository/sqlite/database_provider.dart';
import 'package:kumpulpay/security/password/password.dart';
import 'package:kumpulpay/security/password/password_change.dart';
import 'package:kumpulpay/security/password/password_forgot.dart';
import 'package:kumpulpay/security/pin/pin.dart';
import 'package:kumpulpay/security/pin/pin_create.dart';
import 'package:kumpulpay/splashscreen.dart';
import 'package:kumpulpay/topup/topup.dart';
import 'package:kumpulpay/topup/topup_transfer_manual.dart';
import 'package:kumpulpay/transaction/confirm_pin.dart' as cptransaction;
import 'package:kumpulpay/transaction/history_all.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/verification/address_data.dart';
import 'package:kumpulpay/verification/document_data.dart';
import 'package:kumpulpay/verification/personal_data.dart';
import 'package:kumpulpay/verification/verificationdone.dart';
import 'package:kumpulpay/verification/verify_info.dart';
import 'package:kumpulpay/wallet/transfer/transfer.dart';
import 'package:kumpulpay/wallet/withdraw/withdraw.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseProvider.initialize();
    await SharedPrefs().init();
    await NotificationController().init();
  } catch (e) {
    print('error main init: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ColorNotifire(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: const Splashscreen(),
        initialRoute: Splashscreen.routeName,
        debugShowCheckedModeBanner: false,
        routes: {
          Splashscreen.routeName: (context) => const Splashscreen(),
          Onbonding.routeName: (context) => const Onbonding(),

          Login.routeName: (context) => const Login(),
          Register.routeName: (context) => const Register(),
          Verify.routeName: (context) => const Verify(),
          VerifyInfo.routeName: (context) => const VerifyInfo(),
          PersonalData.routeName: (context) => const PersonalData(),
          AddressData.routeName: (context) => const AddressData(),
          DocumentData.routeName: (context) => const DocumentData(),

          RegionalSearch.routeName: (context) => const RegionalSearch(),

         
          SetupProfile.routeName: (context) => const SetupProfile(),
          Setyourpin.routeName: (context) => const Setyourpin(),
          cplogin.ConfirmPin.routeName: (context) => const cplogin.ConfirmPin(),
          VerificationDone.routeName: (context) => const VerificationDone(),

          Home.routeName: (context) => const Home(),
          Bottombar.routeName: (context) => const Bottombar(),
          NotificationList.routeName: (context) => const NotificationList(),

          Topup.routeName: (context) => const Topup(),
          TopupTransferManual.routeName: (context) => const TopupTransferManual(),
          Withdraw.routeName: (context) => const Withdraw(),
          Transfer.routeName: (context) => const Transfer(),

          Category.routeName: (context) => const Category(),
          ProductProvider.routeName: (context) => const ProductProvider(),

          PpobProduct.routeName: (context) => const PpobProduct(),
          PpobProductDetail.routeName: (context) => const PpobProductDetail(),

          PpobPostpaid.routeName: (context) => const PpobPostpaid(),
          PpobPostpaidSingleProvider.routeName: (context) => const PpobPostpaidSingleProvider(),

          HistoryAll.routeName: (context) => const HistoryAll(),
          cptransaction.ConfirmPin.routeName: (context) => const cptransaction.ConfirmPin(),

          
          EditProfile.routeName: (context) => const EditProfile(),
          
          Pin.routeName: (context) => const Pin(),
          PinCreate.routeName: (context) => const PinCreate(),
          Password.routeName: (context) => const Password(),
          PasswordChange.routeName: (context) => const PasswordChange(),
          PasswordForgot.routeName: (context) => const PasswordForgot(),

          CameraFrameScreen.routeName: (context) => const CameraFrameScreen(),
          
        },
      ),
    ),
  );
}
