import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/journey/bloc/journeys_library_bloc/journeys_library_event.dart';
import 'package:hollybike/journey/bloc/journeys_library_bloc/journeys_library_state.dart';
import 'package:hollybike/journey/widgets/journey_library.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../bloc/journeys_library_bloc/journeys_library_bloc.dart';

class JourneyLibraryModal extends StatefulWidget {
  const JourneyLibraryModal({super.key});

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
    final border = BorderSide(
      color: Theme.of(context).colorScheme.onPrimary,
      width: 3,
    );

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
              border: Border(
                top: border,
                left: border,
                right: border,
              ),
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
                        height: 200,
                        child: BlocBuilder<JourneysLibraryBloc, JourneysLibraryState>(
                          builder: (context, state) {
                            if (state is JourneysLibraryPageLoadInProgress) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return JourneyLibrary(
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
}
