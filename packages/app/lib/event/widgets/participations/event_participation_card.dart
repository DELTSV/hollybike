import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/types/event_participation.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';
import 'package:hollybike/event/widgets/participations/event_participation_actions_menu.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../bloc/event_participations_bloc/event_participations_bloc.dart';
import '../../types/event_role.dart';

class EventParticipationCard extends StatelessWidget {
  final int eventId;
  final EventParticipation participation;
  final bool isOwner;
  final bool isCurrentUser;
  final bool isCurrentUserOrganizer;

  const EventParticipationCard({
    super.key,
    required this.participation,
    required this.isCurrentUser,
    required this.isCurrentUserOrganizer,
    required this.isOwner,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          context.router.pushNamed("/profile/${participation.user.id}");
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        dense: true,
        leading: Hero(
          tag: "profile_picture_participation_${participation.user.id}",
          child: EventLoadingProfilePicture(
            url: participation.user.profilePicture,
            radius: 20,
            userId: participation.user.id,
          ),
        ),
        title: Text(
          participation.user.username,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          _eventRoleName(participation.role),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: EventParticipationActionsMenu(
          participation: participation,
          canEdit: isCurrentUserOrganizer && (!isOwner && !isCurrentUser),
          onPromote: () => _onPromote(context),
          onDemote: () => _onDemote(context),
          onRemove: () => _onRemove(context),
        ),
      ),
    );
  }

  String _eventRoleName(EventRole role) {
    switch (role) {
      case EventRole.organizer:
        return "Organisateur";
      case EventRole.member:
        return "Participant";
    }
  }

  void _onPromote(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<EventParticipationBloc>().add(
            PromoteEventParticipant(
              eventId: eventId,
              userId: participation.user.id,
              session: session,
            ),
          );
    });
  }

  void _onDemote(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<EventParticipationBloc>().add(
            DemoteEventParticipant(
              eventId: eventId,
              userId: participation.user.id,
              session: session,
            ),
          );
    });
  }

  void _onRemove(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<EventParticipationBloc>().add(
            RemoveEventParticipant(
              eventId: eventId,
              userId: participation.user.id,
              session: session,
            ),
          );
    });
  }
}
