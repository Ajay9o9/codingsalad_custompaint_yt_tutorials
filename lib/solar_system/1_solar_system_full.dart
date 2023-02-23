import 'dart:math';

import 'package:canvas_youtube_series/solar_system/planet.dart';
import 'package:flutter/material.dart';

class SolarSystemFull extends StatefulWidget {
  const SolarSystemFull({Key? key}) : super(key: key);

  @override
  State<SolarSystemFull> createState() => _SolarSystemFullState();
}

class _SolarSystemFullState extends State<SolarSystemFull>
    with TickerProviderStateMixin {
  late List<Planet> _planets;

  late List<AnimationController> _planetControllers;
  late AnimationController _sunAnimationController;

  @override
  void initState() {
    _sunAnimationController = AnimationController(
        vsync: this, duration: Duration(seconds: 10), upperBound: 2 * pi);

    _planets = [
      Planet(
        planetName: 'Mercury',
        radius: 5.0,
        orbitRadius: 50.0,
        color: Colors.grey,
      ),
      Planet(
        planetName: 'Venus',
        radius: 10.0,
        orbitRadius: 100.0,
        color: Colors.orangeAccent,
      ),
      Planet(
        planetName: 'Earth',
        radius: 15.0,
        orbitRadius: 150.0,
        color: Colors.blue,
      ),
      Planet(
        planetName: 'Mars',
        radius: 12.0,
        orbitRadius: 200.0,
        color: Colors.red,
      ),
      Planet(
        planetName: 'Juppyter',
        radius: 25.0,
        orbitRadius: 250.0,
        color: Colors.brown,
      ),
      Planet(
        planetName: 'Saturn',
        radius: 22.0,
        orbitRadius: 300.0,
        color: Colors.yellow,
      ),
      Planet(
        planetName: 'Uranus',
        radius: 15.0,
        orbitRadius: 350.0,
        color: Colors.lightBlue,
      ),
      Planet(
        planetName: 'Neptune',
        radius: 15.0,
        orbitRadius: 400.0,
        color: Colors.blue.shade900,
      ),
    ];

    _planetControllers = [
      _createController(
        88,
      ),
      _createController(
        224.7,
      ),
      _createController(
        365,
      ),
      _createController(
        687,
      ),
      _createController(
        4333,
      ),
      _createController(
        10759,
      ),
      _createController(
        30685,
      ),
      _createController(
        60190,
      ),
    ];

    _sunAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _sunAnimationController.repeat();
      }
    });
    _sunAnimationController.forward();

    for (AnimationController controller in _planetControllers) {
      addRepeatListener(controller);
    }

    super.initState();
  }

  addRepeatListener(AnimationController controller) {
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat();
      }
    });
    controller.forward();
  }

  AnimationController _createController(double durationInDays) {
    return AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: ((durationInDays / 365) * 1000).floor()),
        upperBound: 2 * pi)
      ..forward();
  }

  @override
  void dispose() {
    for (AnimationController c in _planetControllers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        maxScale: 10,
        child: AnimatedBuilder(
            animation: _sunAnimationController,
            builder: (context, child) {
              for (int i = 0; i < _planets.length; i++) {
                _planets[i].angle = _planetControllers[i].value;
              }
              return CustomPaint(
                painter: SolarSystemFullPainter(_planets),
                child: Container(),
              );
            }),
      ),
    );
  }
}

class SolarSystemFullPainter extends CustomPainter {
  late List<Planet> _planets;

  SolarSystemFullPainter(this._planets);

  @override
  void paint(Canvas canvas, Size size) {
    print("no of planets is ${_planets.length}");
    final sunPaint = Paint()..color = Colors.yellow;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 30, sunPaint);

    for (int i = 0; i < _planets.length; i++) {
      var planet = _planets[i];
      final radius = planet.radius;
      final orbitRadius = planet.orbitRadius;

      var angle = planet.angle;
      final color = planet.color;

      final planetPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final x = size.width / 2 + orbitRadius * cos(angle);
      final y = size.height / 2 + orbitRadius * sin(angle);

      final orbitPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), orbitRadius, orbitPaint);

      if (i >= 4) {
        final highLightPaint = Paint()
          ..color = Colors.yellow.withOpacity(0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0;

        var rect = Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: orbitRadius);

        canvas.drawArc(rect, 0, angle, false, highLightPaint);
      }
      canvas.drawCircle(Offset(x, y), radius, planetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
