import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_router.gr.dart';
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

  const EventDetailsInfos({
    super.key,
    required this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    final event = eventDetails.event;
    final previewParticipants = eventDetails.previewParticipants;
    final previewParticipantsCount = eventDetails.previewParticipantsCount;

    return EventDetailsScrollWrapper(
      scrollViewKey: 'event_details_infos_${event.id}',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventWarningFeed(event: event),
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
          ],
        ),
      ),
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
