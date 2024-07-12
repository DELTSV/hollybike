import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

import 'user_journey_modal.dart';

class UserJourneyContent extends StatelessWidget {
  final UserJourney existingJourney;
  final MinimalUser? user;
  final Color color;
  final bool isCurrentEvent;

  const UserJourneyContent({
    super.key,
    required this.existingJourney,
    this.user,
    this.color = Colors.transparent,
    required this.isCurrentEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existingJourney.distanceLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                      softWrap: true,
                    ),
                    Text(
                      existingJourney.totalTimeLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: true,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: addSeparators(
                    [
                      Row(
                        children: [
                          const Icon(
                            Icons.north_east_rounded,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${existingJourney.totalElevationGain?.round()} m',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.terrain_rounded,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${existingJourney.maxElevation?.round()} m',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 3),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: addSeparators(
                    [
                      Row(
                        children: [
                          const Icon(
                            Icons.speed_rounded,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            existingJourney.maxSpeedLabel,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.gps_fixed_rounded,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            existingJourney.maxGForceLabel,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 3),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (_) {
                    final eventDetailsBloc = context.readOrNull<EventDetailsBloc>();

                    final modal = UserJourneyModal(
                      journey: existingJourney,
                      user: user,
                      isCurrentEvent: isCurrentEvent,
                    );

                    if (eventDetailsBloc == null) {
                      return modal;
                    }

                    return BlocProvider<EventDetailsBloc>.value(
                      value: eventDetailsBloc,
                      child: modal,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

extension ReadOrNull on BuildContext {
  T? readOrNull<T>() {
    try {
      return read<T>();
    } on ProviderNotFoundException catch (_) {
      return null;
    }
  }
}