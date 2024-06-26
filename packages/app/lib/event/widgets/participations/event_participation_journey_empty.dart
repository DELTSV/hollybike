import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EventParticipationJourneyEmpty extends StatelessWidget {
  final String username;

  const EventParticipationJourneyEmpty({super.key, required this.username,});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      strokeWidth: 2,
      color: Theme
          .of(context)
          .colorScheme
          .onPrimary
          .withOpacity(0.2),
      borderType: BorderType.RRect,
      radius: const Radius.circular(14),
      dashPattern: const [5, 5],
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Lottie.asset(
                'assets/lottie/lottie_journey.json',
                repeat: false,
              ),
            ),
            Expanded(
              child: Text(
                'Lorsque $username aura terminé son trajet, vous pourrez le consulter ici',
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
