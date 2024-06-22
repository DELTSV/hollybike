import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../../shared/utils/with_current_session.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';

enum EventDetailsAction { leave, delete, cancel }

class EventDetailsActionsMenu extends StatelessWidget {
  final int eventId;
  final EventStatusState status;
  final bool isOwner;
  final bool isJoined;
  final bool isOrganizer;

  const EventDetailsActionsMenu({
    super.key,
    required this.eventId,
    required this.status,
    required this.isOwner,
    required this.isJoined,
    required this.isOrganizer,
  });

  @override
  Widget build(BuildContext context) {
    final actions = _buildActions(context);

    if (actions.isEmpty) return const SizedBox();

    return PopupMenuButton(
      itemBuilder: (context) {
        return actions;
      },
      onSelected: (value) => _onSelected(context, value),
    );
  }

  List<PopupMenuItem> _buildActions(BuildContext context) {
    final actions = <PopupMenuItem>[];

    if (isJoined && !isOwner) {
      actions.add(
        const PopupMenuItem(
          value: EventDetailsAction.leave,
          child: Row(
            children: [
              Icon(Icons.exit_to_app),
              SizedBox(width: 10),
              Text("Quitter l'événement"),
            ],
          ),
        ),
      );
    }

    if (isOrganizer && status == EventStatusState.scheduled) {
      actions.add(
        const PopupMenuItem(
          value: EventDetailsAction.cancel,
          child: Row(
            children: [
              Icon(Icons.cancel),
              SizedBox(width: 10),
              Text("Annuler l'événement"),
            ],
          ),
        ),
      );
    }

    if (isOwner) {
      actions.add(
        const PopupMenuItem(
          value: EventDetailsAction.delete,
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 10),
              Text("Supprimer l'événement"),
            ],
          ),
        ),
      );
    }

    return actions;
  }

  void _onSelected(BuildContext context, EventDetailsAction value) {
    switch (value) {
      case EventDetailsAction.leave:
        _onLeave(context);
        break;
      case EventDetailsAction.delete:
        _onDelete(context);
        break;
      case EventDetailsAction.cancel:
        _onCancel(context);
        break;
    }
  }

  void _onCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Annuler l'événement"),
          content:
              const Text("Êtes-vous sûr de vouloir annuler cet événement ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                withCurrentSession(context, (session) {
                  context.read<EventDetailsBloc>().add(
                        CancelEvent(
                          eventId: eventId,
                          session: session,
                        ),
                      );
                });

                Navigator.of(context).pop();
              },
              child: const Text("Annuler l'événement"),
            ),
          ],
        );
      },
    );
  }

  void _onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Supprimer l'événement"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cet événement ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                withCurrentSession(context, (session) {
                  context.read<EventDetailsBloc>().add(
                        DeleteEvent(
                          eventId: eventId,
                          session: session,
                        ),
                      );
                });

                Navigator.of(context).pop();
              },
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  void _onLeave(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<EventDetailsBloc>().add(
            LeaveEvent(
              eventId: eventId,
              session: session,
            ),
          );
    });
  }
}
