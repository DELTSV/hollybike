/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../../../positions/bloc/my_position/my_position_bloc.dart';
import '../../../../positions/bloc/my_position/my_position_state.dart';
import '../position/event_position_switch.dart';
import 'event_cancelled_status.dart';
import 'event_finished_status.dart';
import 'event_now_status.dart';
import 'event_pending_status.dart';
import 'event_scheduled_status.dart';

class EventStatusFeed extends StatelessWidget {
  final EventDetails eventDetails;

  const EventStatusFeed({
    super.key,
    required this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPositionBloc, MyPositionState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildFeed(
              state is MyPositionLoading,
              state.eventId == eventDetails.event.id,
            ),
            EventPositionSwitch(
              eventDetails: eventDetails,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeed(bool isLoading, bool isCurrentEvent) {
    final canEdit = eventDetails.isOrganizer;

    switch (eventDetails.event.status) {
      case EventStatusState.pending:
        return EventPendingStatus(
          eventId: eventDetails.event.id,
          isLoading: isLoading,
        );
      case EventStatusState.canceled:
        return EventCancelledStatus(
          eventId: eventDetails.event.id,
          canCancel: canEdit,
          isLoading: isLoading,
        );
      case EventStatusState.scheduled:
        return EventScheduledStatus(
          eventDetails: eventDetails,
          isLoading: isLoading,
        );
      case EventStatusState.finished:
        return EventFinishedStatus(
          isLoading: isLoading,
          eventDetails: eventDetails,
          isCurrentEvent: isCurrentEvent,
        );
      case EventStatusState.now:
        return EventNowStatus(
          isLoading: isLoading,
          eventDetails: eventDetails,
          isCurrentEvent: isCurrentEvent,
        );
    }
  }
}
