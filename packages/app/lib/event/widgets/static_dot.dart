/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class StaticDot extends StatelessWidget {
  final double size;
  final Color color;

  const StaticDot({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.5,
      height: size * 1.5,
      child: Center(
        child: Icon(
          Icons.circle,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
