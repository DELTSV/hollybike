import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_bloc.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card.dart';

import '../../profile/bloc/profile_journeys_bloc/profile_journeys_event.dart';

class UserJourneyList extends StatelessWidget {
  final bool hasMore;
  final List<UserJourney> userJourneys;
  final MinimalUser user;

  const UserJourneyList({
    super.key,
    required this.hasMore,
    required this.userJourneys,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 16),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              if (index >= userJourneys.length) {
                if (hasMore) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }

              final journey = userJourneys[index];

              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(30 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: UserJourneyCard(
                        showDate: true,
                        journey: journey,
                        color: Theme.of(context).cardColor,
                        user: user,
                        onDeleted: () {
                          context.read<ProfileJourneysBloc>().add(
                            RefreshProfileJourneys(),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: userJourneys.length + (hasMore ? 1 : 0),
          ),
        )
      ],
    );
  }
}
