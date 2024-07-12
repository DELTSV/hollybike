import 'package:flutter/material.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import 'user_journey_content.dart';
import 'empty_user_journey.dart';

class UserJourneyCard extends StatelessWidget {
  final UserJourney? journey;
  final MinimalUser? user;

  const UserJourneyCard({
    super.key,
    required this.journey,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    if (journey == null) {
      return SizedBox(
        height: 80,
        child: EmptyUserJourney(
          username: user?.username,
        ),
      );
    }

    return UserJourneyContent(
      existingJourney: journey!,
      color: Theme.of(context).colorScheme.primaryContainer,
      user: user,
    );
  }
}
