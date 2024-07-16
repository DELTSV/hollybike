/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyJourneyMap extends StatelessWidget {
  const EmptyJourneyMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(56),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Lottie.asset(
                'assets/lottie/lottie_journey.json',
                repeat: false,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun trajet n\'est renseigné pour cet événement.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
