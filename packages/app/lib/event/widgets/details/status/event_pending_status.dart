import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';

import '../../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../../bloc/event_details_bloc/event_details_event.dart';
import '../../../types/event_status_state.dart';

class EventPendingStatus extends StatelessWidget {
  final int eventId;

  const EventPendingStatus({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatusBadge(
      status: EventStatusState.pending,
      message: 'En attente de publication',
      actionText: 'Publier',
      onAction: () {
        _onPublish(context);
      },
    );
  }

  void _onPublish(BuildContext context) {
    context.read<EventDetailsBloc>().add(
      PublishEvent(),
    );
  }
}
