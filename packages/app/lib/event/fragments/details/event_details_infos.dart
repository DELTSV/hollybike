import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card.dart';
import 'package:hollybike/positions/bloc/position_bloc.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/websockets/types/recieve/websocket_subscribed.dart';
import 'package:hollybike/websockets/types/send/websocket_send_position.dart';

import '../../../app/app_router.gr.dart';
import '../../../positions/bloc/position_event.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../../websockets/types/websocket_client.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../types/event_details.dart';
import '../../widgets/details/event_details_scroll_wrapper.dart';
import '../../widgets/details/event_join_button.dart';
import '../../widgets/details/event_participations_preview.dart';
import '../../widgets/details/event_warning_feed.dart';

class EventDetailsInfos extends StatefulWidget {
  final EventDetails eventDetails;
  final void Function() onViewOnMap;

  const EventDetailsInfos({
    super.key,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  State<EventDetailsInfos> createState() => _EventDetailsInfosState();
}

class _EventDetailsInfosState extends State<EventDetailsInfos> {
  String pos = '';
  StreamSubscription<Position>? _positionSubscription;

  @override
  Widget build(BuildContext context) {
    final event = widget.eventDetails.event;
    final previewParticipants = widget.eventDetails.previewParticipants;
    final previewParticipantsCount =
        widget.eventDetails.previewParticipantsCount;

    return EventDetailsTabScrollWrapper(
      scrollViewKey: 'event_details_infos_${event.id}',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventWarningFeed(event: event),
            Text('Position: $pos'),
            ElevatedButton(
              onPressed: () => _onActivatePostions(context),
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
                          eventDetails: widget.eventDetails,
                          participationPreview: previewParticipants,
                        ),
                      );
                    });
                  },
                ),
                EventJoinButton(
                  isJoined: widget.eventDetails.isParticipating,
                  canJoin: widget.eventDetails.canJoin,
                  onJoin: _onJoin,
                ),
              ],
            ),
            const SizedBox(height: 16),
            JourneyPreviewCard(
              canAddJourney: widget.eventDetails.canEditJourney,
              journey: widget.eventDetails.journey,
              eventDetails: widget.eventDetails,
              onViewOnMap: widget.onViewOnMap,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _onActivatePostions(BuildContext context) async {
    _determinePosition().catchError(
      (error) {
        Toast.showErrorToast(context, error.toString());
      },
    ).then((_) async {
      withCurrentSession(context, (session) {
        context.read<PositionBloc>().add(
              ListenAndSendUserPosition(
                session: session,
                eventId: widget.eventDetails.event.id,
              ),
            );
      });
    });
  }

  void _cancelPostions(BuildContext context) {
    context.read<PositionBloc>().add(
          DisableSendPositions(),
        );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  void _onJoin(BuildContext context) {
    withCurrentSession(
      context,
      (session) {
        context.read<EventDetailsBloc>().add(
              JoinEvent(
                eventId: widget.eventDetails.event.id,
                session: session,
              ),
            );
      },
    );
  }
}
