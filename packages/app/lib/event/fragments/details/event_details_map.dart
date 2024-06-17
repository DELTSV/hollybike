import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/map/journey_map.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import '../../widgets/map/empty_journey_map.dart';

class EventDetailsMap extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return EventDetailsScrollWrapper(
      scrollViewKey: 'event_details_map_$eventId',
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (journey == null) {
      return const EmptyJourneyMap();
    }

    return JourneyMap(
      journey: journey!,
      onMapLoaded: onMapLoaded,
    );
  }
}
