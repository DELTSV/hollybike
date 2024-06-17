import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/journey.dart';

import 'journey_library_card.dart';

class JourneyLibrary extends StatelessWidget {
  final List<Journey> journeys;
  final void Function() onAddJourney;
  final void Function(Journey) onSelected;

  const JourneyLibrary({
    super.key,
    required this.journeys,
    required this.onAddJourney,
    required this.onSelected,
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

    return ListView.separated(
      itemCount: journeys.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final journey = journeys[index];

        return JourneyLibraryCard(
          journey: journey,
          onSelected: onSelected,
        );
      },
    );
  }
}
