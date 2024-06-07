import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/utils/with_current_session.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import 'event_warning.dart';

class EventCancelledWarning extends StatelessWidget {
  final int eventId;

  const EventCancelledWarning({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return EventWarning(
      message: "Cet événement est annulé.",
      onAction: () => _onPublish(context),
      actionText: "Publier",
      color: Colors.redAccent.withOpacity(1),
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
