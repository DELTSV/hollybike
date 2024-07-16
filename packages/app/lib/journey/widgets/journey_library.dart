/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/journey/type/journey.dart';

import '../../event/widgets/journey/journey_import_modal_from_type.dart';
import '../../event/widgets/journey/upload_journey_menu.dart';
import 'journey_library_card.dart';

class JourneyLibrary extends StatelessWidget {
  final List<Journey> journeys;
  final Event event;
  final void Function() onAddJourney;
  final void Function(Journey) onSelected;

  const JourneyLibrary({
    super.key,
    required this.journeys,
    required this.event,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: UploadJourneyMenu(
                event: event,
                includeLibrary: false,
                onSelection: (type) {
                  journeyImportModalFromType(
                    context,
                    type,
                    event,
                    selected: onAddJourney,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ajouter un parcours'),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: journeys.length,
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final journey = journeys[index];

          return JourneyLibraryCard(
            journey: journey,
            onSelected: onSelected,
          );
        },
      ),
    );
  }
}
