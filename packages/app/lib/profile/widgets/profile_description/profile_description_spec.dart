/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ProfileDescriptionSpec extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileDescriptionSpec({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary.withAlpha(180),
        ),
        const SizedBox.square(dimension: 8),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(180),
          ),
        )
      ],
    );
  }
}
