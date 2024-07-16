/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ProfilePictureContainer extends StatelessWidget {
  final Widget child;
  final double size;

  const ProfilePictureContainer({
    super.key,
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(Size.square(size)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}
