/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/journey/bloc/journeys_library_bloc/journeys_library_event.dart';
import 'package:hollybike/journey/bloc/journeys_library_bloc/journeys_library_state.dart';
import 'package:hollybike/journey/widgets/journey_library.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';

import '../../event/bloc/event_journey_bloc/event_journey_event.dart';
import '../bloc/journeys_library_bloc/journeys_library_bloc.dart';
import '../type/journey.dart';

class JourneyLibraryModal extends StatefulWidget {
  final Event event;
  final void Function()? onJourneyAdded;

  const JourneyLibraryModal({
    super.key,
    required this.event,
    this.onJourneyAdded,
  });

  @override
  State<JourneyLibraryModal> createState() => _JourneyLibraryModalState();
}

class _JourneyLibraryModalState extends State<JourneyLibraryModal> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<JourneysLibraryBloc>(context).add(
      RefreshJourneysLibrary(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: BlocBuilder<JourneysLibraryBloc, JourneysLibraryState>(
                  builder: (context, state) {
                    final isEmpty = state.journeys.isEmpty;
                    final isLoading =
                        state is JourneysLibraryPageLoadInProgress ||
                            state is JourneysLibraryInitial;

                    final isShrunk =
                        (isLoading && isEmpty) || (isEmpty && !isLoading);

                    return AnimatedContainer(
                      constraints: BoxConstraints(
                        maxHeight: isShrunk ? 150 : 400,
                      ),
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 200),
                      child: _buildLibrary(
                        state.journeys,
                        isLoading && isEmpty,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibrary(List<Journey> journeys, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ThemedRefreshIndicator(
      onRefresh: _onRefresh,
      child: JourneyLibrary(
        event: widget.event,
        onAddJourney: _onAddJourney,
        onSelected: _onSelectedJourney,
        journeys: journeys,
      ),
    );
  }

  Future<void> _onRefresh() {
    final bloc = BlocProvider.of<JourneysLibraryBloc>(context);

    bloc.add(
      RefreshJourneysLibrary(),
    );

    return bloc.firstWhenNotLoading;
  }

  void _onAddJourney() async {
    Navigator.of(context).pop();

    if (widget.onJourneyAdded != null) {
      widget.onJourneyAdded!();
    }
  }

  void _onSelectedJourney(Journey journey) {
    if (widget.onJourneyAdded != null) {
      widget.onJourneyAdded!();
    }

    BlocProvider.of<EventJourneyBloc>(context).add(
      AttachJourneyToEvent(
        journey: journey,
        eventId: widget.event.id,
      ),
    );

    Navigator.of(context).pop();
  }
}
