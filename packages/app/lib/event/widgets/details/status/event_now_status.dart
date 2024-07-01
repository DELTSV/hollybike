import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';

import '../../../../positions/bloc/my_position_bloc.dart';
import '../../../../positions/bloc/my_position_event.dart';
import '../../../bloc/event_details_bloc/event_details_event.dart';
import '../../../types/event_status_state.dart';

class EventNowStatus extends StatelessWidget {
  final EventDetails eventDetails;
  final bool isShared;
  final bool isLoading;

  const EventNowStatus({
    super.key,
    required this.eventDetails,
    required this.isShared,
    this.isLoading = false,
  });

  get canTerminateJourney =>
      eventDetails.callerParticipation?.journey == null &&
      eventDetails.callerParticipation?.hasRecordedPositions == true;

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatusBadge(
      loading: isLoading,
      status: EventStatusState.now,
      message: 'L\'événement est en cours',
      actionText: _getActionText(),
      onAction: _getOnAction(context),
    );
  }

  String? _getActionText() {
    return canTerminateJourney ? 'Terminer le parcours' : null;
  }

  Function()? _getOnAction(BuildContext context) {
    if (!canTerminateJourney) {
      return null;
    }

    return () => {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Terminer le parcours"),
                content: const Text(
                  "Êtes-vous sûr de vouloir terminer le parcours ? Vous ne pourrez plus partager votre position en temps réel.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Annuler"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      context.read<EventDetailsBloc>().add(
                        TerminateUserJourney(
                          eventId: eventDetails.event.id,
                        ),
                      );

                      context.read<MyPositionBloc>().add(
                            DisableSendPositions(),
                          );
                    },
                    child: const Text("Terminer"),
                  ),
                ],
              );
            },
          ),
        };
  }
}
