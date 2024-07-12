import 'package:flutter/material.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import 'user_journey_content.dart';
import 'empty_user_journey.dart';

class UserJourneyCard extends StatelessWidget {
  final UserJourney? journey;
  final MinimalUser? user;
  final Color color;
  final bool isCurrentEvent;
  final void Function()? onDeleted;
  final bool showDate;

  const UserJourneyCard({
    super.key,
    required this.journey,
    required this.color,
    this.user,
    this.isCurrentEvent = false,
    this.onDeleted,
    this.showDate = false,
  });

  @override
  Widget build(BuildContext context) {
    if (journey == null) {
      return SizedBox(
        height: 80,
        child: EmptyUserJourney(
          username: user?.username,
          color: color,
        ),
      );
    }

    return UserJourneyContent(
      existingJourney: journey!,
      color: color,
      user: user,
      isCurrentEvent: isCurrentEvent,
      onDeleted: onDeleted,
      showDate: showDate,
    );
  }
}
