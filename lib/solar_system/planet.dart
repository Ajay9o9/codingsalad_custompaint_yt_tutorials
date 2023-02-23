import 'package:flutter/material.dart';

class Planet {
  String planetName;
  double radius;
  double orbitRadius;
  Color color;
  double angle = 0.0;

  Planet({
    required this.planetName,
    required this.radius,
    required this.orbitRadius,
    required this.color,
  });
}
