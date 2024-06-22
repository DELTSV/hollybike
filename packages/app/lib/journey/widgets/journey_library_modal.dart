import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/journey/bloc/journeys_library_bloc/journeys_library_event.dart';
import 'package:hollybike/journey/bloc/journeys_library_bloc/journeys_library_state.dart';
import 'package:hollybike/journey/widgets/journey_library.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../event/bloc/event_journey_bloc/event_journey_event.dart';
import '../bloc/journeys_library_bloc/journeys_library_bloc.dart';
import '../type/journey.dart';
import '../utils/get_journey_file_and_upload_to_event.dart';

class JourneyLibraryModal extends StatefulWidget {
  final Event event;
  final void Function()? onAddJourney;

  const JourneyLibraryModal({
    super.key,
    required this.event,
    this.onAddJourney,
  });

  @override
  State<JourneyLibraryModal> createState() => _JourneyLibraryModalState();
}

class _JourneyLibraryModalState extends State<JourneyLibraryModal> {
  @override
  void initState() {
    super.initState();

    withCurrentSession(context, (session) {
      BlocProvider.of<JourneysLibraryBloc>(context).add(
        RefreshJourneysLibrary(session: session),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(31),
                topRight: Radius.circular(31),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Selectionnez un parcours',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SizedBox(
                        height: 250,
                        child: BlocBuilder<JourneysLibraryBloc,
                            JourneysLibraryState>(
                          builder: (context, state) {
                            if (state is JourneysLibraryPageLoadInProgress) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return JourneyLibrary(
                              onAddJourney: _onAddJourney,
                              onSelected: _onSelectedJourney,
                              journeys: state.journeys,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onAddJourney() async {
    final file = await getJourneyFileAndUploadToEvent(context, widget.event);

    if (widget.onAddJourney != null) {
      widget.onAddJourney!();
    }

    if (file != null && mounted) Navigator.of(context).pop();
  }

  void _onSelectedJourney(Journey journey) {
    if (widget.onAddJourney != null) {
      widget.onAddJourney!();
    }

    withCurrentSession(context, (session) {
      BlocProvider.of<EventJourneyBloc>(context).add(
        AttachJourneyToEvent(
          session: session,
          journey: journey,
          eventId: widget.event.id,
        ),
      );
    });

    Navigator.of(context).pop();
  }
}
