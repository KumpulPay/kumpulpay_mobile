import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kumpulpay/bottombar/bottombar.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/flavors.dart';
import 'package:kumpulpay/login/register.dart';
import 'package:kumpulpay/login/setupprofile.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/model/data.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/button.dart';
import 'package:kumpulpay/utils/device_info_util.dart';
import 'package:kumpulpay/utils/helpers.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:kumpulpay/utils/string.dart';
import 'package:kumpulpay/utils/textfeilds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colornotifire.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

const List<String> scopes = <String>[
  'email',
  // 'https://www.googleapis.com/auth/userinfo.profile',
  // 'https://www.googleapis.com/auth/user.birthday.read', // Untuk tanggal lahir
  // 'https://www.googleapis.com/auth/user.gender.read', // Untuk jenis kelamin
  // 'https://www.googleapis.com/auth/user.phonenumbers.read', // Untuk nomor telepon
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes
);
class Login extends StatefulWidget {
  static String routeName = '/login';
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _globalKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();
  late ColorNotifire notifire;
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';

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
      print('_currentUserX ${_currentUser}');
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      if (account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      if (isAuthorized) {
        // _handleGetContact(account!);
      }
    });

    _googleSignIn.signInSilently();
  }


  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _onWillPop(),
      child:  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: notifire.getprimerycolor,
          title: Text(
            CustomStrings.login,
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontFamily: 'Gilroy Bold',
                fontSize: height / 35),
          ),
          centerTitle: true,
        ),
        backgroundColor: notifire.getprimerycolor,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: height,
                    width: width,
                    color: Colors.transparent,
                    child:
                        Image.asset("images/background.png", fit: BoxFit.cover),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height / 12.2,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: Container(
                              height: height / 1.2,
                              width: width / 1.1,
                              decoration: BoxDecoration(
                                color: notifire.gettabwhitecolor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height / 15,
                                  ),

                                  _formBuilder(),
                                  
                                  SizedBox(
                                    height: height / 50,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width / 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          height: height / 700,
                                          width: width / 3,
                                          color: Colors.grey.withOpacity(0.4),
                                        ),
                                        Text(
                                          "or",
                                          style: TextStyle(
                                            color: notifire.getdarkgreycolor,
                                            fontSize: height / 50,
                                          ),
                                        ),
                                        Container(
                                          height: height / 700,
                                          width: width / 3,
                                          color: Colors.grey.withOpacity(0.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 50,
                                  ),

                                  // start login with
                                  _loginWith(),
                                  // end login with

                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Belum punya akun?",
                                        style: TextStyle(
                                          color: notifire.getdarkgreycolor
                                              .withOpacity(0.6),
                                          fontSize: height / 50,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 100,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Register.routeName);
                                        },
                                        child: Text(
                                          "Daftar disini",
                                          style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: height / 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: -60,
                            child: Center(
                              child: Image.asset(
                                "images/logo_app/playstore.png",
                                height: height / 7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height / 15,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formBuilder() {
    return FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: width / 18,
                ),
                Text(
                  CustomStrings.email,
                  style: TextStyle(
                    color: notifire.getdarkscolor,
                    fontSize: height / 50,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 70,
            ),
            CustomtextFormBuilderfilds.textField(
                notifire.getdarkscolor,
                notifire.getdarkgreycolor,
                notifire.getPrimaryPurpleColor,
                notifire.getdarkwhitecolor,
                CustomStrings.emailhint,
                name: "email",
                img: "images/email.png",
                isEmail: true,
                initialValue: "client@mail.com"),
            SizedBox(
              height: height / 35,
            ),
            Row(
              children: [
                SizedBox(
                  width: width / 18,
                ),
                Text(
                  CustomStrings.password,
                  style: TextStyle(
                    color: notifire.getdarkscolor,
                    fontSize: height / 50,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 70,
            ),
            CustomtextFormBuilderfilds.textField(
                notifire.getdarkscolor,
                notifire.getdarkgreycolor,
                notifire.getPrimaryPurpleColor,
                notifire.getdarkwhitecolor,
                CustomStrings.passwordhint,
                img: "images/password.png",
                name: "password",
                isPassword: true,
                initialValue: "secret"),
            SizedBox(
              height: height / 35,
            ),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(CustomStrings.commingsoon)));
                  },
                  child: Container(
                    height: height / 40,
                    color: Colors.transparent,
                    child: Text(
                      CustomStrings.forgotpassword,
                      style: TextStyle(
                          color: notifire.getdarkscolor,
                          fontSize: height / 60,
                          fontFamily: 'Gilroy Medium'),
                    ),
                  ),
                ),
                SizedBox(
                  width: width / 18,
                ),
              ],
            ),
            SizedBox(
              height: height / 20,
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  final formData = _formKey.currentState?.value;
                  _handleSubmit(context, formData);
                }
              },
              child: Custombutton.button(
                  notifire.getPrimaryPurpleColor, CustomStrings.login, width / 2),
            ),
          ],
        ));
  }

  Widget _loginWith() {
    return Center(
      child: GestureDetector(
        onTap: _handleSignIn,
        child: Container(
          height: height / 15,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: notifire.getprimerycolor,
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "images/google.png",
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 10),
              Text(
                "Login/Daftar Mudah",
                style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
      //   if (_currentUser == null || _currentUser!.id != account.id) {
          setState(() {
            _currentUser = account;
          });

          var dataAccount = {
            "id": account.id,
            "name": account.displayName,
            "email": account.email,
            "avatar": account.photoUrl
          };
          // Simpan ke SharedPreferences
          SharedPrefs().googleProfile = jsonEncode(dataAccount);

          _handleSignOut();

          authWithGoogle(dataAccount);

          print('User signed in: ${account.displayName}, Email: ${account.email}');

        // } else {
        //   print('aaaaaa');
        // }
      }
    } catch (error) {
      print('Google Sign-In error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $error')),
      );
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _currentUser = null;
    });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Logout berhasil')),
    // );
  }

  Future<void> _handleSubmit(BuildContext context, dynamic formData) async {

    Loading.showLoadingLogoDialog(context, _globalKey);
    
    try {
      var deviceData = await DeviceInfoUtil.initPlatformState();
      dynamic deviceInfo = jsonEncode(deviceData);

      var mutableFormData = Map<String, dynamic>.from(formData);

      mutableFormData['device_info'] = deviceInfo;
     
      final response = await ApiClient(AppConfig().dio).postAuth(params: mutableFormData);

      if (response.success) {
        String token = response.data['token'].toString();
        SharedPrefs().token = token;
        SharedPrefs().userData = jsonEncode(response.data['user']);
        
        await sendTokenFcmToServer(token);

        Navigator.pushNamed(context, Bottombar.routeName);
        
      } else {
        Navigator.pop(context);
        String errorMessage = response.message;
        Map<String, dynamic> errors = response.data;

        List<String> dynamicErrors = [];

        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            dynamicErrors.add('${key}: ${value.join(', ')}');
          }
        });

        if (dynamicErrors.isNotEmpty) {
          errorMessage += '\n' + dynamicErrors.join('\n');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: notifire.getbluecolor,
          ),
        );
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

  Future<void> authWithGoogle(dynamic dataAccount) async {
    Loading.showLoadingLogoDialog(context, _globalKey);
    try {
      var deviceData = await DeviceInfoUtil.initPlatformState();
      dynamic deviceInfo = jsonEncode(deviceData);

      var mutableFormData = Map<String, dynamic>.from(dataAccount);

      mutableFormData['device_info'] = deviceInfo;

      final response = await ApiClient(AppConfig().configDio(context: context))
          .postAuthWithGoogle(params: mutableFormData);
      
      if (response.success) {
        String token = response.data['token'].toString();
        SharedPrefs().token = token;
        SharedPrefs().userData = jsonEncode(response.data['user']);
        await sendTokenFcmToServer(token);

        if (response.data['isNewUser']) {
          Navigator.pushNamed(context, SetupProfile.routeName);
        } else {
          Navigator.pushNamed(context, Bottombar.routeName);
        }
        
      }
    } catch (e) {
      print('Error occurred: $e');
      Navigator.pop(context);
    }
  }

  Future<void> sendTokenFcmToServer(String token) async {
    try {
    
      final response = await ApiClient(AppConfig().configDio(context: context))
          .postUpdateFcm(
          authorization: 'Bearer ${SharedPrefs().token}', body: {
            "fcm_token_mobile": SharedPrefs().fcmTokenMobile,
          });

      if (response.success) {
          // Navigator.pushNamed(context, Bottombar.routeName);
      } else {
          Fluttertoast.showToast(
              msg: 'Fcm token gagal di update!',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda ingin keluar dari halaman ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Ya'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // function google oAuth
  Future<void> _fetchUserProfile() async {
    if (_currentUser == null) return;

    try {
      final auth = await _currentUser!.authentication;
      final accessToken = auth.accessToken;

      // Gunakan token untuk memanggil Google People API
      final response = await http.get(
        Uri.parse(
            'https://people.googleapis.com/v1/people/me?personFields=names,emailAddresses,photos,birthdays,genders,phoneNumbers'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final profileData = jsonDecode(response.body);
   
      final displayName =
          profileData['names']?[0]['displayName'] ?? 'Tidak diketahui';
      final email =
          profileData['emailAddresses']?[0]['value'] ?? 'Tidak diketahui';
      final photoUrl = profileData['photos']?[0]['url'] ?? 'Tidak ada foto';
      final birthday =
          profileData['birthdays']?[0]['date'] ?? 'Tidak diketahui';
      final gender = profileData['genders']?[0]['value'] ?? 'Tidak diketahui';
      final phoneNumber =
          profileData['phoneNumbers']?[0]['value'] ?? 'Tidak diketahui';

      setState(() {
        // Simpan data sesuai kebutuhan
        print('Nama: $displayName');
        print('Email: $email');
        print('Foto: $photoUrl');
        print('Tanggal Lahir: $birthday');
        print('Jenis Kelamin: $gender');
        print('Nomor Telepon: $phoneNumber');
      });
    } catch (e) {
      print('Gagal mendapatkan profil pengguna. Error: $e');
      if (e.toString().contains("SERVICE_DISABLED")) {
        // Tampilkan pesan ke pengguna
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Layanan Tidak Aktif"),
            content: Text(
                "API Google People belum diaktifkan untuk aplikasi ini. Silakan hubungi admin."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse(
          'https://people.googleapis.com/v1/people/me/connections?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'Error: ${response.statusCode}';
      });
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      _contactText = namedContact != null
          ? 'Hello, $namedContact!'
          : 'No contacts available.';
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

}
