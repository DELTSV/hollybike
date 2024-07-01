import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/event_my_journey.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

import '../../../app/app_router.gr.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../types/event_details.dart';
import '../../widgets/details/event_details_scroll_wrapper.dart';
import '../../widgets/details/event_join_button.dart';
import '../../widgets/details/event_participations_preview.dart';
import '../../widgets/details/status/event_status_feed.dart';

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
  Widget build(BuildContext context) {
    final event = widget.eventDetails.event;
    final previewParticipants = widget.eventDetails.previewParticipants;
    final previewParticipantsCount =
        widget.eventDetails.previewParticipantsCount;

    return EventDetailsTabScrollWrapper(
      scrollViewKey: 'event_details_infos_${event.id}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventStatusFeed(eventDetails: widget.eventDetails),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: addSeparators(
                [
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
                  JourneyPreviewCard(
                    canAddJourney: widget.eventDetails.canEditJourney,
                    journey: widget.eventDetails.journey,
                    eventDetails: widget.eventDetails,
                    onViewOnMap: widget.onViewOnMap,
                  ),
                  const EventMyJourney()
                ],
                const SizedBox(height: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onJoin(BuildContext context) {
    context.read<EventDetailsBloc>().add(
      JoinEvent(
        eventId: widget.eventDetails.event.id,
      ),
    );
  }
}
