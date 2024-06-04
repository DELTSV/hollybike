import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_participation.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';
import 'package:hollybike/event/widgets/participations/event_participation_actions_menu.dart';

class EventParticipationCard extends StatelessWidget {
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
                  onPromote: _onPromote,
                  onDemote: _onDemote,
                  onRemove: _onRemove,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPromote() {
    // Handle promote action
  }

  void _onDemote() {
    // Handle demote action
  }

  void _onRemove() {
    // Handle remove action
  }
}
