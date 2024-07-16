/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherForecastEmptyCard extends StatelessWidget {
  final String message;

  const WeatherForecastEmptyCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      strokeWidth: 2,
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
      borderType: BorderType.RRect,
      radius: const Radius.circular(14),
      dashPattern: const [5, 5],
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/lottie_earth.json',
              height: 60,
            ),
            const SizedBox(width: 11),
            Flexible(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
