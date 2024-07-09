import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_modal.dart';
import 'package:hollybike/journey/widgets/journey_tools_modal.dart';

import '../../../journey/bloc/journeys_library_bloc/journeys_library_bloc.dart';
import '../../../journey/service/journey_repository.dart';
import '../../../journey/utils/get_journey_file_and_upload_to_event.dart';
import '../../../journey/widgets/journey_library_modal.dart';
import '../../bloc/event_journey_bloc/event_journey_event.dart';

void journeyImportModalFromType(
  BuildContext context,
  NewJourneyType type,
  Event event, {
  void Function()? selected,
}) async {
  Future<void> uploadJourneyFile(File file, bool isGpx) async {
    BlocProvider.of<EventJourneyBloc>(context).add(
      UploadJourneyFileToEvent(
        eventId: event.id,
        name: event.name,
        file: file,
      ),
    );

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<EventJourneyBloc>(context),
          child: UploadJourneyModal(
            isGpx: isGpx,
          ),
        );
      },
    );
  }

  switch (type) {
    case NewJourneyType.library:
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return BlocProvider.value(
            value: BlocProvider.of<EventJourneyBloc>(context),
            child: BlocProvider<JourneysLibraryBloc>(
              create: (context) => JourneysLibraryBloc(
                journeyRepository: RepositoryProvider.of<JourneyRepository>(
                  context,
                ),
              ),
              child: JourneyLibraryModal(
                event: event,
                onJourneyAdded: () {
                  selected?.call();
                },
              ),
            ),
          );
        },
      );
      break;
    case NewJourneyType.file:
      final platformFile = await getJourneyFile(context, event);

      final filePath = platformFile?.path;

      if (filePath != null) {
        final file = File(filePath);

        final isGpx = platformFile?.extension == '.gpx';

        await uploadJourneyFile(file, isGpx);

        selected?.call();
      }
      break;
    case NewJourneyType.external:
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return JourneyToolsModal(
            onGpxDownloaded: (file) async {
              Navigator.of(context).pop();
              await uploadJourneyFile(file, true);
              selected?.call();
            },
          );
        },
      );

      break;
  }
}
