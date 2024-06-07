import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/event_warning.dart';

import '../../../shared/utils/with_current_session.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';

class EventPendingWarning extends StatelessWidget {
  final int eventId;

  const EventPendingWarning({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return EventWarning(
      message: "Cet événement en attente.",
      onAction: () => _onPublish(context),
      actionText: "Publier",
      color: Colors.blueAccent,
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
