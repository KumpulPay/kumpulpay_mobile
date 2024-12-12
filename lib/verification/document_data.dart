import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kumpulpay/repository/app_config.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/loading.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:mnc_identifier_face/mnc_identifier_face.dart';
import 'package:mnc_identifier_face/model/liveness_detection_result_model.dart';
// import 'package:mnc_identifier_ocr/mnc_identifier_ocr.dart';
// import 'package:mnc_identifier_ocr/model/ocr_result_model.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentData extends StatefulWidget {
  static String routeName = '/document_data';
  final Map<String, dynamic>? receivedFormData;
  const DocumentData({Key? key, this.receivedFormData}) : super(key: key);

  @override
  State<DocumentData> createState() => _DocumentDataState();
}

class _DocumentDataState extends State<DocumentData> {
  DocumentData? args;
  late ColorNotifire notifire;
  final _globalKey = GlobalKey<State>();
  Map<String, dynamic>? _receivedFormData;
  bool cameraIsGranted = false;
  LivenessDetectionResult? livenessResult;
  final _mncIdentifierFacePlugin = MncIdentifierFace();
  // OcrResultModel? ocrResultModel;
  
  // Future<void> scanKtp() async {
  //   OcrResultModel? res;
  //   try {
  //     res = await MncIdentifierOcr.startCaptureKtp(
  //         withFlash: true, cameraOnly: true);
  //   } catch (e) {
  //     debugPrint('something goes wrong $e');
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     ocrResultModel = res;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)!.settings.arguments as DocumentData?;
      _receivedFormData = args!.receivedFormData;
    });
   
  }

  _imgCmr() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    debugPrint('path: ${image?.path}');
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
            'Data Dokumen',
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
                          addPhoto('Ambil foto KTP kamu disini*', 'ktp'),
                          SizedBox(height: height / 40),
                          addPhoto('Verifikasi wajah*', 'vermuk'),
                        ],
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
                        // padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        
                        // if (_formKey.currentState?.saveAndValidate() ?? false) {
                        //   final formData = _formKey.currentState?.value;
                        //   print('Form Data: $formData');
                        // } else {
                        //   print('Validation failed');
                        // }
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
          )
          
        ));
  }

  Widget addPhoto(String txtLabel, String type) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 50),
      child: GestureDetector(
        onTap: () async {
          await _checkAndRequestCameraPermission();
          if (cameraIsGranted) {
            if (type == 'ktp') {
              _imgCmr();
            } else {
              livenessResult =
                        await _mncIdentifierFacePlugin.startLivenessDetection();
              print('livenessResult ${livenessResult?.toJson().toString() ?? "Data still empty"}');
            }
          }
        },
        child: DottedBorder(
          strokeWidth: 2,
          dashPattern: const [5, 5],
          borderType: BorderType.RRect,
          color: notifire.getbluecolor,
          radius: const Radius.circular(20),
          child: Container(
            width: double.infinity, // Membuat lebar penuh
            height: height / 6.5,
            decoration: BoxDecoration(
              color: notifire.getprimerydarkcolor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/AddCard.png"),
                  SizedBox(height: height / 40), // Spasi antara gambar dan teks
                  Text(
                    txtLabel,
                    style: TextStyle(
                      color: notifire.getdarkscolor,
                      fontFamily: 'GilroyMedium',
                      fontSize: height / 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _postData(dynamic formData) async {
    Loading.showLoadingLogoDialog(context, _globalKey);
    try {
      final dynamic body = {
        'email': formData['email'],
        'phone': formData['phone'],
      };
      print('bodyX ${body}');
      final response =
          await ApiClient(AppConfig().configDio()).postAccountChecker(body: body);
      Navigator.pop(context);
      print('responseX ${response}');
      if (response.success) {
      } else {
        String errorMessage = response.message;
        Map<String, dynamic> errors = response.data;
        print('errorMessageX ${errorMessage}');
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
      print('erroX ${e.toString()}');
      Navigator.pop(context);
      rethrow;
    }
  }

  Future<void> _checkAndRequestCameraPermission() async {
    if (await Permission.camera.isGranted) {
      // Permission already granted
      print('Camera permission already granted');
      cameraIsGranted = true;
    } else {
      // Request permission
      final status = await Permission.camera.request();
      if (status.isGranted) {
        cameraIsGranted = true;
        print('Camera permission granted');
      } else if (status.isDenied) {
        cameraIsGranted = false;
        print('Camera permission denied');
      } else if (status.isPermanentlyDenied) {
        cameraIsGranted = false;
        print('Camera permission permanently denied. Please enable it from settings.');
        openAppSettings();
      }
    }
  }

  // Future<bool> _checkAndRequestCameraPermission() async {
  //   if (await Permission.camera.request().isGranted) {
  //     return true;
  //   } else {
  //     // Handle permission denied
  //     print('Camera permission denied');
  //     return false;
  //   }
  // }
}
