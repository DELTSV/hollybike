import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_state.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/journey/widgets/journey_library_modal.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';
import 'package:lottie/lottie.dart';

import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../bloc/event_journey_bloc/event_journey_event.dart';

enum NewJourneyType {
  library,
  file,
}

class EmptyJourneyPreviewCard extends StatelessWidget {
  final Event event;

  const EmptyJourneyPreviewCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventJourneyBloc, EventJourneyState>(
      listener: (context, state) {
        if (state is EventJourneyCreationSuccess) {
          print('EventJourneyCreationSuccess');
        }

        if (state is EventJourneyUploadSuccess) {
          print('EventJourneyUploadSuccess');
        }
      },
      child: DottedBorder(
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
              PopupMenuButton(
                icon: const Text('Sélectionner un parcours'),
                onSelected: (type) => _onItemSelect(context, type),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: NewJourneyType.library,
                      child: Text('Depuis la bibliothèque'),
                    ),
                    const PopupMenuItem(
                      value: NewJourneyType.file,
                      child: Text('Importer un fichier GPX/GEOJSON'),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemSelect(BuildContext context, NewJourneyType type) async {
    switch (type) {
      case NewJourneyType.library:
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return const JourneyLibraryModal();
          },
        );
        break;
      case NewJourneyType.file:
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.any,
        );

        if (result == null) {
          return;
        }

        final extension = result.files.single.extension;

        if (extension != 'gpx' && extension != 'geojson') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Fichier invalide"),
                content:
                    const Text("Le fichier doit être au format GPX ou GEOJSON"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );

          return;
        }

        File file = File(result.files.single.path!);

        withCurrentSession(context, (session) async {
          BlocProvider.of<EventJourneyBloc>(context).add(
            UploadJourneyFileToEvent(
              session: session,
              eventId: event.id,
              name: event.name,
              file: file,
            ),
          );
        });

        print('Importer un fichier GPX/GEOJSON');
    }
  }
}
