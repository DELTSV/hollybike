import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card.dart';
import 'package:hollybike/positions/bloc/position_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/app_router.gr.dart';
import '../../../positions/bloc/position_event.dart';
import '../../../positions/bloc/position_state.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../types/event_details.dart';
import '../../widgets/details/event_details_scroll_wrapper.dart';
import '../../widgets/details/event_join_button.dart';
import '../../widgets/details/event_participations_preview.dart';
import '../../widgets/details/event_warning_feed.dart';

class EventDetailsInfos extends StatelessWidget {
  final EventDetails eventDetails;
  final void Function() onViewOnMap;

  const EventDetailsInfos({
    super.key,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  Widget _buildPosition(LocationDto? location) {
    if (location == null) {
      return const Text('No location');
    }

    final str = 'Lat: ${location.latitude}, Lng: ${location.longitude}';
    return Text(str);
  }

  @override
  Widget build(BuildContext context) {
    final event = eventDetails.event;
    final previewParticipants = eventDetails.previewParticipants;
    final previewParticipantsCount =
        eventDetails.previewParticipantsCount;

    return EventDetailsTabScrollWrapper(
      scrollViewKey: 'event_details_infos_${event.id}',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PositionBloc, PositionState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventWarningFeed(event: event),
                _buildPosition(state.lastLocation),
                Text('Is running: ${state.isRunning}'),
                ElevatedButton(
                  onPressed: () => _onStart(context),
                  child: const Text('Position'),
                ),
                ElevatedButton(
                  onPressed: () => _cancelPostions(context),
                  child: const Text('Cancel'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EventParticipationsPreview(
                      event: event,
                      previewParticipants: previewParticipants,
                      previewParticipantsCount: previewParticipantsCount,
                      onTap: () {
                        Timer(const Duration(milliseconds: 100), () {
                          context.router.push(
                            EventParticipationsRoute(
                              eventDetails: eventDetails,
                              participationPreview: previewParticipants,
                            ),
                          );
                        });
                      },
                    ),
                    EventJoinButton(
                      isJoined: eventDetails.isParticipating,
                      canJoin: eventDetails.canJoin,
                      onJoin: _onJoin,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                JourneyPreviewCard(
                  canAddJourney: eventDetails.canEditJourney,
                  journey: eventDetails.journey,
                  eventDetails: eventDetails,
                  onViewOnMap: onViewOnMap,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onStart(BuildContext context) async {
    if (await _checkLocationPermission() && context.mounted) {
      withCurrentSession(context, (session) {
        context.read<PositionBloc>().add(
          EnableSendPosition(
            session: session,
            eventId: eventDetails.event.id,
          ),
        );
      });
    }
  }

  Future<bool> _checkLocationPermission() async {
    final perm = await Permission.location.request();
    await Permission.notification.request();

    return perm.isGranted;
  }

  void _cancelPostions(BuildContext context) {
    context.read<PositionBloc>().add(
      DisableSendPositions(),
    );
  }

  void _onJoin(BuildContext context) {
    withCurrentSession(
      context,
          (session) {
        context.read<EventDetailsBloc>().add(
          JoinEvent(
            eventId: eventDetails.event.id,
            session: session,
          ),
        );
      },
    );
  }
}
