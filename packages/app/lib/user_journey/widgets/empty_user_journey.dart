import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyUserJourney extends StatelessWidget {
  final String? username;
  final Color color;

  const EmptyUserJourney({
    super.key,
    this.username,
    required this.color,
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
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
                _getMessage(),
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

  String _getMessage() {
    if (username == null) {
      return 'Lorsque vous aurez terminé votre trajet, vous pourrez le consulter ici';
    }

    return 'Lorsque $username aura terminé son trajet, vous pourrez le consulter ici';
  }
}
