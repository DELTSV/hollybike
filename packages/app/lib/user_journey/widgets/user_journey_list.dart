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
  final bool isNested;
  final void Function(UserJourney)? onJourneySelected;

  const UserJourneyList({
    super.key,
    required this.hasMore,
    required this.userJourneys,
    required this.user,
    this.isNested = true,
    this.onJourneySelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (isNested)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 16),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
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
                        onJourneySelected: onJourneySelected,
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
        ),
        if (hasMore)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
