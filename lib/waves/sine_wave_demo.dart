import 'dart:math';

import 'package:flutter/material.dart';

class SineWaveWidget extends StatefulWidget {
  const SineWaveWidget({Key? key}) : super(key: key);

  @override
  State<SineWaveWidget> createState() => _SineWaveWidgetState();
}

class _SineWaveWidgetState extends State<SineWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _sineAnimController;
  late Animation<double> _sineAnimation;

  @override
  void initState() {
    _sineAnimController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _sineAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
        CurvedAnimation(parent: _sineAnimController, curve: Curves.linear));

    _sineAnimController.forward();
    _sineAnimController.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedBuilder(
            animation: _sineAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: SinePainter(_sineAnimation),
                child: Container(),
              );
            }));
  }
}

class SinePainter extends CustomPainter {
  final Animation<double> _animation;

  SinePainter(this._animation);

  @override
  void paint(Canvas canvas, Size size) {
    //create a gradient paint
    Paint gradientPaint = Paint()
      ..shader = LinearGradient(colors: [
        Colors.blue,
        Colors.redAccent,
        Colors.blue[200]!,
        Colors.blue[100]!,
        Colors.green[500]!,
        Colors.red[50]!,
        Colors.blue[100]!,
        Colors.blue[200]!,
      ], begin: Alignment.topRight, end: Alignment.bottomLeft)
          .createShader(Rect.fromLTWH(10, 0, size.width, size.height))
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    Path path = Path()..moveTo(0, size.height / 2);

    for (int i = 1; i <= 30; i++) {
      path.lineTo(
        i * size.width / 30, //x position from left to right
        size.height / 2 +
            sin(_animation.value + i * pi / 15) * 20, //y position oscillating
      );
    }

    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
