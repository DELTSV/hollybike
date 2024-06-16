import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/journey.dart';

class JourneyLibrary extends StatelessWidget {
  final List<Journey> journeys;

  const JourneyLibrary({
    super.key,
    required this.journeys,
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
              onPressed: () {},
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
