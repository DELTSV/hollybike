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
      strokeWidth: 4,
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
      borderType: BorderType.RRect,
      radius: const Radius.circular(14),
      dashPattern: const [5, 5],
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Lottie.asset(
              'assets/lottie/lottie_journey.json',
              repeat: false,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Sélectionner un parcours',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
