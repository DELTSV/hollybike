import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/archived_events_bloc.dart';

import '../../app/app_router.gr.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../shared/utils/with_current_session.dart';
import '../../shared/widgets/app_toast.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../bloc/events_bloc/events_event.dart';
import '../bloc/events_bloc/events_state.dart';
import '../bloc/events_bloc/future_events_bloc.dart';
import '../types/minimal_event.dart';
import '../widgets/event_image.dart';
import '../widgets/event_list.dart';

class ArchivedEvents extends StatelessWidget {
  const ArchivedEvents({super.key});

  @override
  Widget build(BuildContext context) {
    _refreshEvents(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSessionSwitched) {
              _refreshEvents(context);
            }
          },
        ),
        BlocListener<FutureEventsBloc, EventsState>(listener: (context, state) {
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
      child: BlocBuilder<ArchivedEventsBloc, EventsState>(
        builder: (context, state) {
          if (state.events.isEmpty) {
            switch (state.status) {
              case EventStatus.initial:
                return const SizedBox();
              case EventStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case EventStatus.error:
                return const Center(
                  child: Text('Oups, une erreur est survenue.'),
                );
              case EventStatus.success:
                return const Center(
                  child: Text('Aucun post trouvé.'),
                );
            }
          }

          return EventList(
            hasMore: state.hasMore,
            events: state.events,
            onNextPageRequested: () {
              _loadNextPage(context);
            },
            onEventTap: (event) {
              _navigateToEventDetails(
                context,
                event,
                true,
              );
            },
            onRefreshRequested: () {
              _refreshEvents(context);
            },
          );
        },
      ),
    );
  }

  void _loadNextPage(BuildContext context) {
    withCurrentSession(context, (session) {
      context
          .read<ArchivedEventsBloc>()
          .add(LoadEventsNextPage(session: session));
    });
  }

  void _refreshEvents(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<ArchivedEventsBloc>().add(RefreshEvents(session: session));
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
}
