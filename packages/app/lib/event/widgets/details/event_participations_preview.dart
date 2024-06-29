import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';

import '../../types/participation/event_participation.dart';

class EventParticipationsPreview extends StatelessWidget {
  final Event event;
  final List<EventParticipation> previewParticipants;
  final int previewParticipantsCount;

  final void Function() onTap;

  final avatarSize = 43.0;
  final avatarRadius = 43.0 / 2;
  final borderSize = 4.0;

  const EventParticipationsPreview({
    super.key,
    required this.event,
    required this.previewParticipants,
    required this.previewParticipantsCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 14 - borderSize,
            right: 14,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              SizedBox(
                height: avatarSize,
                width:
                (previewParticipants.length * avatarRadius) + avatarRadius,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: previewParticipants.asMap().entries.map((entry) {
                    final participation = entry.value;
                    final index = entry.key;

                    final avatar = Hero(
                      tag:
                      "profile_picture_participation_${participation.user.id}",
                      child: Container(
                        width: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: borderSize,
                          ),
                        ),
                        child: EventLoadingProfilePicture(
                          url: participation.user.profilePicture,
                          radius: avatarRadius,
                          userId: participation.user.id,
                        ),
                      ),
                    );

                    if (index == 0) {
                      return avatar;
                    }

                    return Positioned(
                      top: -borderSize,
                      left: avatarRadius * index.toDouble(),
                      child: avatar,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              _getParticipantsText(
                context,
                previewParticipants.length,
                previewParticipantsCount,
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getParticipantsText(BuildContext context, int count, int totalCount) {
    if (totalCount == 1) {
      return Text(
        "1 participant",
        style: Theme.of(context).textTheme.titleSmall,
      );
    }

    if (totalCount > 5) {
      return Text(
        "+ ${totalCount - 5}",
        style: Theme.of(context).textTheme.titleSmall,
      );
    }

    return const SizedBox();
  }
}
