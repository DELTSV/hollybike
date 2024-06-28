import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/map/journey_map.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/positions/bloc/user_positions_bloc.dart';
import 'package:hollybike/positions/bloc/user_positions_state.dart';
import 'package:hollybike/positions/types/recieve/websocket_receive_position.dart';
import 'package:hollybike/shared/widgets/async_renderer.dart';
import 'package:provider/provider.dart';

import '../../../auth/bloc/auth_bloc.dart';
import '../../../positions/bloc/user_positions_event.dart';
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
    return EventDetailsTabScrollWrapper(
      scrollViewKey: 'event_details_map_$eventId',
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final currentSession =
        Provider.of<AuthPersistence>(context).currentSession;

    if (journey == null || currentSession == null) {
      return const EmptyJourneyMap();
    }

    return AsyncRenderer(
      future: currentSession as FutureOr<AuthSession>,
      placeholder: const Text("placeholder"),
      builder: (session) => BlocProvider(
        create: (context) => UserPositionsBloc()
          ..add(
            SubscribeToUserPositions(
              eventId: eventId,
              session: session,
            ),
          ),
        child: BlocBuilder<UserPositionsBloc, UserPositionsState>(
          builder: (context, state) {
            return Column(
              children: [
                if (state.status == UserPositionsStatus.success)
                  ..._buildUserPositions(state.userPositions),
                JourneyMap(
                  journey: journey!,
                  onMapLoaded: onMapLoaded,
                ),
              ],
            );
          },
        ),
      ),
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
