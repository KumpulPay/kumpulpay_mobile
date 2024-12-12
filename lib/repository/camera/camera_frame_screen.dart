import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/utils/colornotifire.dart';
import 'package:kumpulpay/utils/media.dart';
import 'package:provider/provider.dart';

class CameraFrameScreen extends StatefulWidget {
  static String routeName = '/camera_frame';
  const CameraFrameScreen({Key? key}) : super(key: key);

  @override
  State<CameraFrameScreen> createState() => _CameraFrameScreenState();
}

class _CameraFrameScreenState extends State<CameraFrameScreen> {
  late ColorNotifire notifire;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false, // Audio tidak diperlukan
      );

      _initializeControllerFuture = _cameraController.initialize();
      setState(() {
        isCameraReady = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      await _initializeControllerFuture; // Tunggu kamera siap
      final photo = await _cameraController.takePicture();

      print('Photo saved to: ${photo.path}');
      Navigator.pop(context, photo.path);
    } catch (e) {
      print('Error taking photo: $e');
    }
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
          'Ambil Foto',
          style: TextStyle(
            color: notifire.getdarkscolor,
            fontFamily: 'Gilroy Bold',
            fontSize: height / 40,
          ),
        ),
        centerTitle: true,
      ),
      body: 
      Stack(
          children: [
            if (isCameraReady)
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_cameraController);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            // Gambar frame sebagai overlay
            Positioned.fill(
              child: Image.asset(
                'images/Scan.png', // Ganti dengan path file gambar Anda
                fit: BoxFit.fill,
              ),
            ),
            // Tombol capture
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _takePhoto,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.camera_alt),
                  ),
                ],
              ),
            ),
          ],
        )

      // Stack(
      //   children: [
      //     if (isCameraReady)
      //       FutureBuilder<void>(
      //         future: _initializeControllerFuture,
      //         builder: (context, snapshot) {
      //           if (snapshot.connectionState == ConnectionState.done) {
      //             return CameraPreview(_cameraController);
      //           } else {
      //             return const Center(child: CircularProgressIndicator());
      //           }
      //         },
      //       ),
      //     // Overlay frame
      //     Positioned.fill(
      //       child: CustomPaint(
      //         painter: FramePainter(),
      //       ),
      //     ),
      //     // Tombol capture
      //     Positioned(
      //       bottom: 20,
      //       left: 0,
      //       right: 0,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           FloatingActionButton(
      //             onPressed: _takePhoto,
      //             backgroundColor: Colors.green,
      //             child: const Icon(Icons.camera_alt),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint untuk garis
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Rect utama untuk bingkai KTP
    final mainRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.4),
      width: size.width * 0.8,
      height: size.height * 0.4,
    );

    // Rect kecil untuk profil di bawahnya
    final profileRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.75),
      width: size.width * 0.2,
      height: size.height * 0.1,
    );

    // Gambar bingkai utama
    canvas.drawRRect(
      RRect.fromRectAndRadius(mainRect, const Radius.circular(16)),
      paint,
    );

    // Gambar bingkai profil
    canvas.drawRRect(
      RRect.fromRectAndRadius(profileRect, const Radius.circular(8)),
      paint,
    );

    // Teks "Mohon Posisikan Kartu"
    final textPainter = TextPainter(
      text: const TextSpan(
        text:
            "Mohon Posisikan Kartu di sini. Klik layar untuk memperjelas foto.",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width * 0.6,
    );

    textPainter.paint(
      canvas,
      Offset(size.width * 0.2, size.height * 0.1),
    );

    // Icon Rotate dan Teks
    final iconPainter = TextPainter(
      text: const TextSpan(
        text: "↺\nRotate your phone",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    iconPainter.layout(
      maxWidth: size.width * 0.2,
    );

    iconPainter.paint(
      canvas,
      Offset(size.width * 0.4, size.height * 0.85),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
