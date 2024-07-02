import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';

import '../../../journey/bloc/journeys_library_bloc/journeys_library_bloc.dart';
import '../../../journey/service/journey_repository.dart';
import '../../../journey/utils/get_journey_file_and_upload_to_event.dart';
import '../../../journey/widgets/journey_library_modal.dart';

void journeyImportModalFromType(
    BuildContext context, NewJourneyType type, Event event,
    {void Function()? selected}) async {
  switch (type) {
    case NewJourneyType.library:
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return BlocProvider<JourneysLibraryBloc>(
            create: (context) => JourneysLibraryBloc(
              journeyRepository:
              RepositoryProvider.of<JourneyRepository>(
                context,
              ),
            ),
            child: JourneyLibraryModal(
              event: event,
              onAddJourney: () {
                selected?.call();
              },
            )
          );
        },
      );
      break;
    case NewJourneyType.file:
      final file = await getJourneyFileAndUploadToEvent(context, event);

      if (file != null) {
        selected?.call();
      }
      break;
  }
}
