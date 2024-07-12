import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
import 'package:hollybike/event/widgets/map/journey_map.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_bloc.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_state.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';


class EventDetailsMap extends StatefulWidget {
  final int eventId;
  final MinimalJourney? journey;
  final void Function() onMapLoaded;

  const EventDetailsMap({
    super.key,
    required this.eventId,
    required this.journey,
    required this.onMapLoaded,
  });

  @override
  State<EventDetailsMap> createState() => _EventDetailsMapState();
}

class _EventDetailsMapState extends State<EventDetailsMap> {
  @override
  void initState() {
    super.initState();

    context.read<UserPositionsBloc>().add(
      SubscribeToUserPositions(
        eventId: widget.eventId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPositionsBloc, UserPositionsState>(
      builder: (context, state) {
        if (widget.journey == null && state.userPositions.isEmpty) {
          return ThemedRefreshIndicator(
            onRefresh: () => _refreshEventDetails(context),
            child: ScrollablePlaceholder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: MediaQuery
                  .of(context)
                  .size
                  .width * 0.1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Lottie.asset(
                      fit: BoxFit.cover,
                      'assets/lottie/lottie_journey.json',
                      repeat: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun trajet lié à cet évènement ou aucun utilisateur ne partage sa position.',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return EventDetailsTabScrollWrapper(
          scrollViewKey: 'event_details_map_${widget.eventId}',
          child: JourneyMap(
            journey: widget.journey,
            onMapLoaded: widget.onMapLoaded,
            userPositions: state.userPositions,
          ),
        );
      },
    );
  }

  Future<void> _refreshEventDetails(BuildContext context) {
    context.read<EventDetailsBloc>().add(
      LoadEventDetails(),
    );

    return context
        .read<EventDetailsBloc>()
        .firstWhenNotLoading;
  }
}
