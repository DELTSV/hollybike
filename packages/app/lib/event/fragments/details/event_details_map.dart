import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/map/journey_map.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/positions/bloc/user_positions_bloc.dart';
import 'package:hollybike/positions/bloc/user_positions_state.dart';
import 'package:hollybike/positions/types/recieve/websocket_receive_position.dart';
import 'package:provider/provider.dart';

import '../../../positions/bloc/user_positions_event.dart';
import '../../widgets/map/empty_journey_map.dart';

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
    return EventDetailsTabScrollWrapper(
      scrollViewKey: 'event_details_map_${widget.eventId}',
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final currentSession = Provider.of<AuthPersistence>(context).currentSession;

    if (widget.journey == null || currentSession == null) {
      return const EmptyJourneyMap();
    }

    return BlocBuilder<UserPositionsBloc, UserPositionsState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.status == UserPositionsStatus.success)
              ..._buildUserPositions(state.userPositions),
            JourneyMap(
              journey: widget.journey!,
              onMapLoaded: widget.onMapLoaded,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildUserPositions(
      List<WebsocketReceivePosition> userPositions) {
    return userPositions.map((position) {
      return Row(
        children: [
          Text(position.userId.toString()),
          const SizedBox(width: 10),
          Text('${position.latitude.toString()}, '),
          Text(position.longitude.toString()),
        ],
      );
    }).toList();
  }
}
