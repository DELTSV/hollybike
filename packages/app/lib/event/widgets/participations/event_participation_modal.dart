import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/participation/event_participation.dart';
import 'package:hollybike/shared/utils/dates.dart';

import '../event_loading_profile_picture.dart';
import 'event_participation_journey.dart';

class EventParticipationModal extends StatelessWidget {
  final EventParticipation participation;

  const EventParticipationModal({
    super.key,
    required this.participation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UserProfilePicture(
                      url: participation.user.profilePicture,
                      radius: 20,
                      userId: participation.user.id,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          participation.user.username,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          participation.roleName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _onOpenUserProfile(context),
                      child: const Text("Voir le profil"),
                    )
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Inscrit ${formatTimeDate(participation.joinedDateTime.toLocal())}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              EventParticipationJourney(
                journey: participation.journey,
                user: participation.user,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onOpenUserProfile(BuildContext context) {
    context.router.pushNamed("/profile/${participation.user.id}");
  }
}
