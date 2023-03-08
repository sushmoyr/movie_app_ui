import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movie_app_ui/colors.dart';
import 'dart:ui' as ui;

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            WelcomeBanner(),
            SizedBox(height: 24),
            Text(
              "Watch movies in Virtual Reality",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Download and watch offline  wherever you are',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            Button(),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ButtonPainter(),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
        child: Text(
          "Sign up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final RRect border =
        RRect.fromRectAndRadius(rect, Radius.circular(size.height));
    Paint paint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        colors: [neonPink, neonBlue],
      ).createShader(rect);

    double blurAmount = 30;
    Paint pinkCircle = Paint()
      ..color = neonPink
      ..imageFilter = ui.ImageFilter.blur(
        sigmaY: blurAmount,
        sigmaX: blurAmount,
        tileMode: TileMode.decal,
      );
    Paint blueCircle = Paint()
      ..color = neonBlue
      ..imageFilter = ui.ImageFilter.blur(
        sigmaY: blurAmount,
        sigmaX: blurAmount,
        tileMode: TileMode.decal,
      );
    Offset circleOffset = Offset(size.height / 2, 0);
    canvas.drawCircle(size.centerLeft(Offset.zero) + circleOffset,
        size.height / 2, pinkCircle);
    canvas.drawCircle(size.centerRight(Offset.zero) - circleOffset,
        size.height / 2, blueCircle);
    canvas.drawRRect(border, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WelcomeBanner extends StatefulWidget {
  const WelcomeBanner({Key? key}) : super(key: key);

  @override
  State<WelcomeBanner> createState() => _WelcomeBannerState();
}

class _WelcomeBannerState extends State<WelcomeBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _SomePainter(_controller),
          size: Size.square(constraints.biggest.shortestSide),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClipOval(
              child: Image.asset(
                'assets/vr_girl.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SomePainter extends CustomPainter {
  const _SomePainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    // double startAngle = 0;
    // double sweepAngle = 3.14156 / 2;
    double value = animation.value;
    //
    // Offset start = Tween<Offset>(
    //   begin: size.topLeft(Offset.zero),
    //   end: size.bottomRight(Offset.zero),
    // ).animate(animation).value;
    //
    // Offset end = Tween<Offset>(
    //   begin: size.bottomRight(Offset.zero),
    //   end: size.topLeft(Offset.zero),
    // ).animate(animation).value;
    // print(size.topLeft(Offset.zero));
    // print(size.bottomRight(Offset.zero));
    double t = size.width / 2;
    // double t = (3 * size.width) / 8;
    double angle = 2 * pi * value;

    Offset pinkSide = size.center(Offset.zero) + Offset.fromDirection(angle, t);
    Offset greenSide =
        size.center(Offset.zero) + Offset.fromDirection(angle, -t);

    Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..shader = ui.Gradient.linear(pinkSide, greenSide, [
        neonPink,
        Colors.transparent,
        Colors.transparent,
        neonGreen,
      ], [
        0,
        0.4,
        0.6,
        1.0
      ]);

    double blurAmount = 100;

    Paint circle1Paint = Paint()
      ..color = neonPink
      ..imageFilter = ui.ImageFilter.blur(
          sigmaX: blurAmount, sigmaY: blurAmount, tileMode: TileMode.decal);
    Paint circle2Paint = Paint()
      ..color = neonGreen
      ..imageFilter = ui.ImageFilter.blur(
          sigmaX: blurAmount, sigmaY: blurAmount, tileMode: TileMode.decal);

    canvas.drawCircle(pinkSide, size.width / 4, circle1Paint);

    canvas.drawCircle(greenSide, size.width / 4, circle2Paint);
    // canvas.drawCircle(
    //     size.bottomRight(Offset.zero), size.width / 2, circle2Paint);
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
