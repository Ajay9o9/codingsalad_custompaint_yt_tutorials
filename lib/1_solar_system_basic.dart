import 'dart:math';

import 'package:flutter/material.dart';

class SolarSystemBasic extends StatefulWidget {
  const SolarSystemBasic({Key? key}) : super(key: key);

  @override
  State<SolarSystemBasic> createState() => _SolarSystemBasicState();
}

class _SolarSystemBasicState extends State<SolarSystemBasic>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 10), upperBound: 2 * pi);
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.forward();
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        maxScale: 10,
        child: CustomPaint(
          painter: SolarSystemBasicPainter(_animationController),
          child: Container(),
        ),
      ),
    );
  }
}

class SolarSystemBasicPainter extends CustomPainter {
  final Animation<double> animation;

  SolarSystemBasicPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final sunPaint = Paint()..color = Colors.yellow;
    final orbitPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke;
    final earthPaint = Paint()..color = Colors.blue.withOpacity(0.9);

    const earthRadius = 20.0;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 200, orbitPaint);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, sunPaint);

    canvas.drawCircle(
        Offset(size.width / 2 + 200 * cos(animation.value),
            size.height / 2 + 200 * sin(animation.value)),
        earthRadius,
        earthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
