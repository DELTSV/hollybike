import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_participation.dart';

import '../../types/event_role.dart';

enum EventParticipationAction { promote, demote, remove }

class EventParticipationActionsMenu extends StatelessWidget {
  final EventParticipation participation;
  final void Function() onPromote;
  final void Function() onDemote;
  final void Function() onRemove;
  final bool canEdit;

  const EventParticipationActionsMenu({
    super.key,
    required this.participation,
    required this.onPromote,
    required this.onDemote,
    required this.onRemove,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (!canEdit) {
      return const SizedBox();
    }

    return PopupMenuButton<EventParticipationAction>(
      itemBuilder: (BuildContext context) {
        return _buildActions(context);
      },
      onSelected: _onSelected,
    );
  }

  void _onSelected(EventParticipationAction value) {
    switch (value) {
      case EventParticipationAction.promote:
        onPromote();
        break;
      case EventParticipationAction.demote:
        onDemote();
        break;
      case EventParticipationAction.remove:
        onRemove();
        break;
    }
  }

  _buildActions(BuildContext context) {
    final actions = <PopupMenuItem<EventParticipationAction>>[];

    if (participation.role == EventRole.organizer) {
      actions.add(
        const PopupMenuItem(
          value: EventParticipationAction.demote,
          child: Row(
            children: [
              Icon(Icons.arrow_downward),
              SizedBox(width: 10),
              Text("Rétrograder membre"),
            ],
          ),
        ),
      );
    } else if (participation.role == EventRole.member) {
      actions.add(
        const PopupMenuItem(
          value: EventParticipationAction.promote,
          child: Row(
            children: [
              Icon(Icons.arrow_upward),
              SizedBox(width: 10),
              Text("Promouvoir organisateur"),
            ],
          ),
        ),
      );
    }

    actions.add(
      const PopupMenuItem(
        value: EventParticipationAction.remove,
        child: Row(
          children: [
            Icon(Icons.remove),
            SizedBox(width: 10),
            Text("Retirer de l'événement"),
          ],
        ),
      ),
    );

    return actions;
  }
}
