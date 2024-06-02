import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_participation.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';

class EventParticipationCard extends StatelessWidget {
  final EventParticipation participation;
  final void Function() onPromote;
  final void Function() onDemote;
  final void Function() onRemove;

  const EventParticipationCard({
    super.key,
    required this.participation,
    required this.onPromote,
    required this.onDemote,
    required this.onRemove,
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
                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: "promote",
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward),
                            SizedBox(width: 10),
                            Text("Promouvoir organisateur"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "demote",
                        child: Row(
                          children: [
                            Icon(Icons.arrow_downward),
                            SizedBox(width: 10),
                            Text("Rétrograder membre"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "remove",
                        child: Row(
                          children: [
                            Icon(Icons.remove),
                            SizedBox(width: 10),
                            Text("Retirer de l'événement"),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (String value) {
                    switch (value) {
                      case "promote":
                        onPromote();
                        break;
                      case "demote":
                        onDemote();
                        break;
                      case "remove":
                        onRemove();
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
