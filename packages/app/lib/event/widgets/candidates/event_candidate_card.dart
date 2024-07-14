import 'package:flutter/material.dart';

import '../../types/participation/event_candidate.dart';
import '../../types/participation/event_role.dart';
import '../event_loading_profile_picture.dart';

class EventCandidateCard extends StatelessWidget {
  final EventCandidate candidate;
  final bool isSelected;
  final bool alreadyParticipating;
  final void Function() onTap;

  const EventCandidateCard({
    super.key,
    required this.candidate,
    required this.isSelected,
    required this.onTap,
    required this.alreadyParticipating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: CheckboxListTile(
        value: isSelected,
        enabled: !alreadyParticipating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onChanged: (_) => onTap(),
        secondary: UserProfilePicture(
          url: candidate.profilePicture,
          profilePictureKey: candidate.profilePictureKey,
          radius: 20,
        ),
        title: Text(
          candidate.username,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: candidate.eventRole != null
            ? Text(
                "Déjà ${_eventRoleName(candidate.eventRole!)}",
                style: Theme.of(context).textTheme.bodyMedium,
              )
            : null,
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
}
