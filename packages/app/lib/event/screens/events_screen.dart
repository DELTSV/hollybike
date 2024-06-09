import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/event_image.dart';
import 'package:hollybike/event/widgets/event_list.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../app/app_router.gr.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../shared/widgets/app_toast.dart';
import '../bloc/events_bloc/events_event.dart';
import '../bloc/events_bloc/events_state.dart';

@RoutePage()
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  void _loadNextPage(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<EventsBloc>().add(LoadEventsNextPage(session: session));
    });
  }

  void _refreshEvents(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<EventsBloc>().add(RefreshEvents(session: session));
    });
  }

  void _navigateToEventDetails(
    BuildContext context,
    MinimalEvent event,
    bool animate,
  ) {
    // delay 200 ms to allow the animation to finish
    Future.delayed(const Duration(milliseconds: 200), () {
      context.router.push(EventDetailsRoute(
        eventId: event.id,
        eventImage: EventImage(event: event),
        eventName: event.name,
        animate: animate,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return EventList(
      onNextPageRequested: _loadNextPage,
      onEventTap: (event) {
        _navigateToEventDetails(
          context,
          event,
          true,
        );
      },
      onRefreshRequested: _refreshEvents,
      blocListeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSessionSwitched) {
              _refreshEvents(context);
            }
          },
        ),
        BlocListener<EventsBloc, EventsState>(listener: (context, state) {
          if (state is EventCreationSuccess) {
            Toast.showSuccessToast(context, "Événement créé");

            Future.delayed(const Duration(milliseconds: 50), () {
              _navigateToEventDetails(
                  context, state.createdEvent.toMinimalEvent(), false);

              Future.delayed(const Duration(milliseconds: 200), () {
                _refreshEvents(context);
              });
            });
          }

          if (state is EventCreationFailure) {
            Toast.showErrorToast(context, state.errorMessage);
          }
        }),
        BlocListener<EventDetailsBloc, EventDetailsState>(
          listener: (context, state) {
            if (state is DeleteEventSuccess) {
              Toast.showSuccessToast(context, "Événement supprimé");
              _refreshEvents(context);
            }
          },
        ),
      ],
    );
  }
}
