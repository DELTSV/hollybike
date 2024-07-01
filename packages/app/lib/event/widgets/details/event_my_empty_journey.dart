import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EventMyEmptyJourney extends StatelessWidget {
  const EventMyEmptyJourney({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      strokeWidth: 2,
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
      borderType: BorderType.RRect,
      radius: const Radius.circular(14),
      dashPattern: const [5, 5],
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Lottie.asset(
              'assets/lottie/lottie_journey.json',
              repeat: false,
            ),
            Flexible(
              child: Text(
                'Une fois terminé, votre trajet sera disponible ici',
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
