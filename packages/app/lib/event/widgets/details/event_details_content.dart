import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/details/event_warning_feed.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import 'event_participations_preview.dart';

class EventDetailsContent extends StatelessWidget {
  final EventDetails eventDetails;

  const EventDetailsContent({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    final event = eventDetails.event;
    final previewParticipants = eventDetails.previewParticipants;
    final previewParticipantsCount = eventDetails.previewParticipantsCount;

    return Padding(
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
                        eventId: event.id,
                        participationPreview: previewParticipants,
                      ),
                    );
                  });
                },
              ),
              ElevatedButton(
                onPressed: () => _onJoin(context),
                child: const Text("Rejoindre"),
              ),
            ],
          ),
        ],
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
