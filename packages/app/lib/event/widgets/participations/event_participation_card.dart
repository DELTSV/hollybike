import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/types/event_participation.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';
import 'package:hollybike/event/widgets/participations/event_participation_actions_menu.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../bloc/event_participations_bloc/event_participations_bloc.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle container tap
          // Navigator.of(context).pushNamed(
          //   AppRoutes.profile,
          //   arguments: ProfileScreenArguments(
          //     userId: participation.user.id,
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              key: ValueKey(participation.user.id),
              children: [
                Hero(
                  tag: "profile_picture_participation_${participation.user.id}",
                  child: EventLoadingProfilePicture(
                    url: participation.user.profilePicture,
                    radius: 20,
                    userId: participation.user.id,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  participation.user.username,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                EventParticipationActionsMenu(
                  participation: participation,
                  canEdit:
                      isCurrentUserOrganizer && (!isOwner && !isCurrentUser),
                  onPromote: () => _onPromote(context),
                  onDemote: () => _onDemote(context),
                  onRemove: () => _onRemove(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
