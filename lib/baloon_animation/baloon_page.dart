import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'baloon.dart';

class BaloonPage extends StatefulWidget {
  const BaloonPage({Key? key}) : super(key: key);

  @override
  State<BaloonPage> createState() => _BaloonPageState();
}

class _BaloonPageState extends State<BaloonPage>
    with SingleTickerProviderStateMixin {
  final List<Baloon> _baloons = [];
  late AnimationController _animationController;
  late Timer _timer;
  double wind = 0.1;
  double speed = 0.1;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    _startAnimation();
    super.initState();
  }

  _startAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        for (final baloon in _baloons) {
          baloon.x += wind * baloon.windDirection;
          baloon.y -= speed;
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomPaint(
        painter: BaloonPainter(_baloons, _animationController.value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
                onPressed: () {
                  _baloons.add(Baloon(
                      x: Random().nextDouble() * width,
                      y: Random().nextDouble() * height,
                      color: Colors
                          .primaries[_baloons.length % Colors.primaries.length],
                      windDirection: Random().nextBool() ? -1 : 1));
                  setState(() {});
                },
                icon: Icon(
                  Icons.add_box_rounded,
                  size: 50,
                )),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class BaloonPainter extends CustomPainter {
  final List<Baloon> _baloons;
  final double animationValue;

  BaloonPainter(this._baloons, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final baloon in _baloons) {
      final paint = Paint()..color = baloon.color;

      final threadPaint = Paint()..color = Colors.grey;

      canvas.drawLine(
        Offset(baloon.x, baloon.y),
        Offset(baloon.x, baloon.y + 100),
        threadPaint,
      );

      canvas.drawCircle(Offset(baloon.x, baloon.y), 50, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
