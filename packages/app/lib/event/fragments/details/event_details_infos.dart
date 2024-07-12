import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/event_details_description.dart';
import 'package:hollybike/event/widgets/details/event_my_journey.dart';
import 'package:hollybike/event/widgets/expenses/expenses_preview_card.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card.dart';
import 'package:hollybike/weather/widgets/weather_forecast_card.dart';

import '../../../app/app_router.gr.dart';
import '../../../journey/service/journey_repository.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../services/event/event_repository.dart';
import '../../types/event_details.dart';
import '../../widgets/details/event_details_scroll_wrapper.dart';
import '../../widgets/details/event_join_button.dart';
import '../../widgets/details/event_participations_preview.dart';
import '../../widgets/details/status/event_status_feed.dart';

class EventDetailsInfos extends StatelessWidget {
  final EventDetails eventDetails;
  final void Function() onViewOnMap;

  const EventDetailsInfos({
    super.key,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final event = eventDetails.event;
    final previewParticipants = eventDetails.previewParticipants;
    final previewParticipantsCount = eventDetails.previewParticipantsCount;

    return EventDetailsTabScrollWrapper(
      scrollViewKey: 'event_details_infos_${event.id}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventStatusFeed(eventDetails: eventDetails),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
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
                              eventDetailsBloc: context.read<EventDetailsBloc>(),
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
                EventDetailsDescription(
                  description: event.description,
                ),
                BlocProvider<EventJourneyBloc>(
                  create: (context) => EventJourneyBloc(
                    journeyRepository: RepositoryProvider.of<JourneyRepository>(
                      context,
                    ),
                    eventRepository: RepositoryProvider.of<EventRepository>(
                      context,
                    ),
                  ),
                  child: JourneyPreviewCard(
                    canAddJourney: eventDetails.canEditJourney,
                    journey: eventDetails.journey,
                    eventDetails: eventDetails,
                    onViewOnMap: onViewOnMap,
                  ),
                ),
                EventMyJourney(
                  eventDetails: eventDetails,
                ),
                WeatherForecastCard(
                  eventDetails: eventDetails,
                ),
                ExpensesPreviewCard(eventDetails: eventDetails),
                const SizedBox(height: 90),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onJoin(BuildContext context) {
    context.read<EventDetailsBloc>().add(
          JoinEvent(),
        );
  }
}
