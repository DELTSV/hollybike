/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class BarContainer extends StatelessWidget {
  final Widget? child;

  const BarContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).colorScheme.primary,
        ),
        height: double.infinity,
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        clipBehavior: Clip.hardEdge,
        child: child,
      ),
    );
  }
}
