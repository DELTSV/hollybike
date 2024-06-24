import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card.dart';
import 'package:hollybike/positions/bloc/position_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/app_router.gr.dart';
import '../../../positions/bloc/position_event.dart';
import '../../../shared/utils/with_current_session.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final start = SizedBox(
    //   width: double.maxFinite,
    //   child: ElevatedButton(
    //     child: Text('Start'),
    //     onPressed: () {
    //       _onStart();
    //     },
    //   ),
    // );
    // final stop = SizedBox(
    //   width: double.maxFinite,
    //   child: ElevatedButton(
    //     child: Text('Stop'),
    //     onPressed: () {
    //       onStop();
    //     },
    //   ),
    // );
    // String msgStatus = "-";
    // if (isRunning) {
    //   msgStatus = 'Is running';
    // } else {
    //   msgStatus = 'Is not running';
    // }
    // final status = Text("Status: $msgStatus");
    //
    // final log = Text(
    //   logStr,
    // );
    //
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Flutter background Locator'),
    //     ),
    //     body: Container(
    //       width: double.maxFinite,
    //       padding: const EdgeInsets.all(22),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[start, stop, status, log],
    //         ),
    //       ),
    //     ),
    //   ),
    // );

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
            ElevatedButton(
              onPressed: () => _onStart(),
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

  void _onStart() async {
    if (await _checkLocationPermission()) {
      withCurrentSession(context, (session) {
        context.read<PositionBloc>().add(
              ListenAndSendUserPosition(
                session: session,
                eventId: widget.eventDetails.event.id,
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
                eventId: widget.eventDetails.event.id,
                session: session,
              ),
            );
      },
    );
  }
}
