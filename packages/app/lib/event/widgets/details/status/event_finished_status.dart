/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_bloc.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_event.dart';
import 'package:hollybike/shared/utils/dates.dart';

class EventFinishedStatus extends StatelessWidget {
  final EventDetails eventDetails;
  final bool isLoading;
  final bool isCurrentEvent;

  get canTerminateJourney =>
      eventDetails.callerParticipation?.journey == null &&
      eventDetails.callerParticipation?.hasRecordedPositions == true;

  const EventFinishedStatus({
    super.key,
    required this.eventDetails,
    required this.isLoading,
    this.isCurrentEvent = false,
  });

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatusBadge(
      status: EventStatusState.finished,
      message: 'Terminé ${formatPastTime(
        eventDetails.event.endDate ??
            eventDetails.event.startDate.add(const Duration(hours: 4)),
      )}',
      loading: isLoading,
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

    return () =>
    {
      showDialog(
        context: context,
        builder: (contextDialog) {
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
                    TerminateUserJourney(),
                  );

                  if (isCurrentEvent) {
                    context.read<MyPositionBloc>().add(
                      DisableSendPositions(),
                    );
                  }
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
