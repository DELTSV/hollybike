import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';
import 'package:hollybike/event/widgets/participations/event_participation_actions_menu.dart';
import 'package:hollybike/event/widgets/participations/event_participation_modal.dart';

import '../../bloc/event_participations_bloc/event_participations_bloc.dart';
import '../../types/participation/event_participation.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        onTap: () {
          _onOpenParticipationModal(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        dense: true,
        leading: Hero(
          tag: "profile_picture_participation_${participation.user.id}",
          child: UserProfilePicture(
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
          participation.roleName,
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

  void _onPromote(BuildContext context) {
    context.read<EventParticipationBloc>().add(
          PromoteEventParticipant(
            userId: participation.user.id,
          ),
        );
  }

  void _onDemote(BuildContext context) {
    context.read<EventParticipationBloc>().add(
          DemoteEventParticipant(
            userId: participation.user.id,
          ),
        );
  }

  void _onRemove(BuildContext context) {
    context.read<EventParticipationBloc>().add(
          RemoveEventParticipant(
            userId: participation.user.id,
          ),
        );
  }

  void _onOpenParticipationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return EventParticipationModal(
          participation: participation,
        );
      },
    );
  }
}
