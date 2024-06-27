import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:lottie/lottie.dart';

class EmptyJourneyPreviewCard extends StatelessWidget {
  final Event event;

  const EmptyJourneyPreviewCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      strokeWidth: 2,
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
      borderType: BorderType.RRect,
      radius: const Radius.circular(14),
      dashPattern: const [5, 5],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Lottie.asset(
                      'assets/lottie/lottie_journey.json',
                      repeat: false,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Aucun parcours sélectionné',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ],
              ),
            ),
            const Text('Sélectionner un parcours'),
          ],
        ),
      ),
    );
  }
}
