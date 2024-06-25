import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../positions/bloc/my_position_bloc.dart';
import '../../../../positions/bloc/my_position_event.dart';
import '../../../../shared/utils/with_current_session.dart';
import '../../../types/event_status_state.dart';

class EventNowStatus extends StatelessWidget {
  final EventDetails eventDetails;
  final bool isShared;

  const EventNowStatus({
    super.key,
    required this.eventDetails,
    required this.isShared,
  });

  @override
  Widget build(BuildContext context) {
    if (isShared) {
      return EventDetailsStatus(
        status: EventStatusState.now,
        message: 'Votre position est partagée',
        action: TextButton(
          onPressed: () => _cancelPostions(context),
          child: Text(
            'Désactiver',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      );
    }

    if (eventDetails.isParticipating) {
      return EventDetailsStatus(
        status: EventStatusState.now,
        message: 'Partagez votre position',
        action: TextButton(
          onPressed: () => _onStart(context),
          child: Text(
            'Activer',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      );
    }

    return const EventDetailsStatus(
      status: EventStatusState.now,
      message: 'L\'événement est en cours',
    );
  }

  void _onStart(BuildContext context) async {
    if (await _checkLocationPermission() && context.mounted) {
      withCurrentSession(context, (session) {
        context.read<MyPositionBloc>().add(
          EnableSendPosition(
            session: session,
            eventId: eventDetails.event.id,
            eventName: eventDetails.event.name,
          ),
        );
      });
    }
  }

  Future<bool> _checkLocationPermission() async {
    final perm = await Permission.location.request();
    await Permission.notification.request();

    return perm.isGranted;
  }

  void _cancelPostions(BuildContext context) {
    context.read<MyPositionBloc>().add(
      DisableSendPositions(),
    );
  }
}
