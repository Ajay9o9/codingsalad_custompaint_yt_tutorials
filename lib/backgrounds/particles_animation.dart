import 'dart:async';
import 'dart:math';

import 'package:canvas_youtube_series/backgrounds/particle.dart';
import 'package:flutter/material.dart';

class ParticleAnimations extends StatefulWidget {
  const ParticleAnimations({Key? key}) : super(key: key);

  @override
  State<ParticleAnimations> createState() => _ParticleAnimationsState();
}

class _ParticleAnimationsState extends State<ParticleAnimations> {
  late List<Particle> particles;

  @override
  void initState() {
    particles = [];

    for (int i = 0; i < 200; i++) {
      particles.add(Particle(width: 600, height: 701));
    }

    update();
    super.initState();
  }

  update() {
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onPanUpdate: (details) {
          var localPosition = details.localPosition;

          particles.add(Particle(width: 600, height: 700)
            ..x = localPosition.dx
            ..y = localPosition.dy);

          setState(() {});
        },
        child: CustomPaint(
          painter: ParticlesPainter(particles: particles),
          child: Container(),
        ),
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;

  ParticlesPainter({required this.particles});

  //eucledian distance formula
  double dist(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < particles.length; i++) {
      var particle = particles[i];

      if (particle.x < 0 || particle.x > size.width) {
        particles[i].xSpeed *= -1;
      }

      if (particle.y < 0 || particle.y > size.height) {
        particles[i].ySpeed *= -1;
      }

      particles[i].x += particle.xSpeed;
      particles[i].y += particle.ySpeed;

      for (var j = i + 1; j < particles.length; j++) {
        var nxtParticle = particles[j];

        var distance =
            dist(particle.x, particle.y, nxtParticle.x, nxtParticle.y);

        if (distance < 85) {
          var linePaint = Paint()
            ..color = Colors.pink.withOpacity(0.9)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4;

          Offset point1 = Offset(particle.x, particle.y);
          Offset point2 = Offset(nxtParticle.x, nxtParticle.y);

          canvas.drawLine(point1, point2, linePaint);
        }
      }

      var paint = Paint()
        ..color = Colors.pink.shade600
        ..style = PaintingStyle.fill;

      var circlePosition = Offset(particle.x, particle.y);

      canvas.drawCircle(circlePosition, particle.r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
