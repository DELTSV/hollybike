import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card.dart';
import 'package:hollybike/event/widgets/pulsing_dot.dart';
import 'package:hollybike/event/widgets/static_dot.dart';
import 'package:hollybike/shared/utils/dates.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/app_router.gr.dart';
import '../../../positions/bloc/my_position_bloc.dart';
import '../../../positions/bloc/my_position_event.dart';
import '../../../positions/bloc/my_position_state.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../types/event_details.dart';
import '../../types/event_status_state.dart';
import '../../widgets/details/event_details_scroll_wrapper.dart';
import '../../widgets/details/event_join_button.dart';
import '../../widgets/details/event_participations_preview.dart';
import '../../widgets/details/event_details_status.dart';
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
  Widget build(BuildContext context) {
    final event = widget.eventDetails.event;
    final previewParticipants = widget.eventDetails.previewParticipants;
    final previewParticipantsCount =
        widget.eventDetails.previewParticipantsCount;

    return EventDetailsTabScrollWrapper(
      scrollViewKey: 'event_details_infos_${event.id}',
      child: BlocBuilder<MyPositionBloc, MyPositionState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSharedPosition(context, state.isRunning, state.eventId),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    EventWarningFeed(event: event),
                    const SizedBox(height: 10),
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
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildSharedPosition(
      BuildContext context, bool isShared, int? eventId) {
    if (isShared && eventId == widget.eventDetails.event.id) {
      return EventDetailsStatus(
        prefix: PulsingDot(
          size: 15,
          color: Theme.of(context).colorScheme.secondary,
        ),
        message: 'Votre position est partagée',
        action: TextButton(
          onPressed: () => _cancelPostions(context),
          child: Text(
            'Désactiver',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
      );
    }

    if (widget.eventDetails.isParticipating &&
        widget.eventDetails.event.status == EventStatusState.now) {
      return EventDetailsStatus(
        prefix: PulsingDot(
          size: 15,
          color: Theme.of(context).colorScheme.secondary,
        ),
        message: 'Partagez votre position',
        action: TextButton(
          onPressed: () => _onStart(context),
          child: Text(
            'Activer',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
      );
    }

    if (widget.eventDetails.event.status == EventStatusState.scheduled) {
      return EventDetailsStatus(
        // Simple circle icon
        prefix: StaticDot(
          size: 15,
          color: Colors.green.shade400,
        ),
        message: fromDateToDuration(widget.eventDetails.event.startDate),
        action: TextButton(
          onPressed: () {
            // add to calendar
          },
          child: Text(
            'Ajouter au calendrier',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.green.shade400,
                ),
          ),
        )
      );
    }

    if (widget.eventDetails.event.status == EventStatusState.finished) {
      return EventDetailsStatus(
        prefix: StaticDot(
          size: 15,
          color: Colors.grey,
        ),
        message: 'Terminé le ${fromDateToDuration(widget.eventDetails.event.startDate)}',
        action: SizedBox(),
      );
    }

    if (widget.eventDetails.event.status == EventStatusState.canceled) {
      return EventDetailsStatus(
        prefix: StaticDot(
          size: 15,
          color: Colors.red.shade400,
        ),
        message: 'Evénement annulé',
        action: TextButton(
          onPressed: () {
            // add to calendar
          },
          child: Text(
            'Publier',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.red.shade400,
            ),
          ),
        )
      );
    }

    if (widget.eventDetails.event.status == EventStatusState.pending) {
      return EventDetailsStatus(
        prefix: StaticDot(
          size: 15,
          color: Colors.blue.shade400,
        ),
        message: 'En attente de publication',
        action: TextButton(
          onPressed: () {
            // add to calendar
          },
          child: Text(
            'Publier',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.blue.shade400,
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  void _onStart(BuildContext context) async {
    if (await _checkLocationPermission() && context.mounted) {
      withCurrentSession(context, (session) {
        context.read<MyPositionBloc>().add(
              EnableSendPosition(
                session: session,
                eventId: widget.eventDetails.event.id,
                eventName: widget.eventDetails.event.name,
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
    context.read<MyPositionBloc>().add(
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
