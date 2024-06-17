import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/journey.dart';

class JourneyLibrary extends StatelessWidget {
  final List<Journey> journeys;
  final void Function() onAddJourney;

  const JourneyLibrary({
    super.key,
    required this.journeys,
    required this.onAddJourney,
  });

  @override
  Widget build(BuildContext context) {
    if (journeys.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Aucun parcours disponible.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAddJourney,
              child: const Text('Ajouter un fichier GPX/GEOJSON'),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      child: Center(
        child: Text('Journey Library ${journeys.length}'),
      ),
    );
  }
}
