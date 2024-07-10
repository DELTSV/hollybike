import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../../../positions/bloc/my_position_bloc.dart';
import '../../../../positions/bloc/my_position_state.dart';
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
    switch (eventDetails.event.status) {
      case EventStatusState.pending:
        return EventPendingStatus(eventId: eventDetails.event.id);
      case EventStatusState.canceled:
        return EventCancelledStatus(eventId: eventDetails.event.id);
      case EventStatusState.scheduled:
        return EventScheduledStatus(
          eventDetails: eventDetails,
        );
      case EventStatusState.finished:
        return EventFinishedStatus(
          endDate: eventDetails.event.endDate ??
              eventDetails.event.startDate.add(const Duration(hours: 4)),
        );
      case EventStatusState.now:
        return BlocBuilder<MyPositionBloc, MyPositionState>(
          builder: (context, state) {
            return Column(
              children: [
                EventNowStatus(
                  isLoading: state is MyPositionLoading,
                  eventDetails: eventDetails,
                  isShared:
                      state.isRunning && state.eventId == eventDetails.event.id,
                ),
                EventPositionSwitch(
                  eventDetails: eventDetails,
                ),
              ],
            );
          },
        );
    }
  }
}
