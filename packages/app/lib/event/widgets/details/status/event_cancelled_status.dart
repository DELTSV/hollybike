import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';

import '../../../../shared/utils/with_current_session.dart';
import '../../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../../bloc/event_details_bloc/event_details_event.dart';
import '../../../types/event_status_state.dart';

class EventCancelledStatus extends StatelessWidget {
  final int eventId;

  const EventCancelledStatus({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatus(
        status: EventStatusState.canceled,
        message: 'Evénement annulé',
        action: TextButton(
          onPressed: () {
            _onPublish(context);
          },
          child: Text(
            'Publier',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.red.shade400,
            ),
          ),
        )
    );
  }

  void _onPublish(BuildContext context) {
    withCurrentSession(
      context,
      (session) {
        context.read<EventDetailsBloc>().add(
              PublishEvent(
                eventId: eventId,
                session: session,
              ),
            );
      },
    );
  }
}
