import 'dart:math';

import 'package:flutter/material.dart';
class Loading {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(), // Loading indicator
                SizedBox(width: 20.0),
                Text('Loading...'), // Text indicating loading
              ],
            ),
          ),
        );
      },
    );
  }
  // images/logo_app/playstore.png

static Future<void> showLoadingLogoDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _RotatingCircle(), // Animasi lingkaran berputar
                  _FadingLogo(), // Animasi fade in-out logo
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Animasi Rotasi Lingkaran
class _RotatingCircle extends StatefulWidget {
  @override
  State<_RotatingCircle> createState() => _RotatingCircleState();
}

class _RotatingCircleState extends State<_RotatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Animasi terus berputar
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        width: 80,
        height: 80,
        child: CustomPaint(
          painter: _CirclePainter(), // Desain lingkaran berputar
        ),
      ),
    );
  }
}

// Desain Lingkaran Berputar
class _CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 241, 121, 121)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const int circleCount = 12;
    for (int i = 0; i < circleCount; i++) {
      final double angle = (i / circleCount) * 2 * 3.14159;
      final double x = size.width / 2 + 30 * cos(angle);
      final double y = size.height / 2 + 30 * sin(angle);
      canvas.drawCircle(Offset(x, y), 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Animasi Fade In-Out pada Logo
class _FadingLogo extends StatefulWidget {
  @override
  State<_FadingLogo> createState() => _FadingLogoState();
}

class _FadingLogoState extends State<_FadingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Animasi fade in-out bolak-balik

    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Image.asset(
        'images/logo_app/playstore.png', // Path ke logo
        width: 60,
        height: 60,
      ),
    );
  }
}
