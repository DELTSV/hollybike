import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';

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
import '../widgets/event_list.dart';

class UserEvents extends StatefulWidget {
  final int? userId;

  const UserEvents({
    super.key,
    required this.userId,
  });

  @override
  State<UserEvents> createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {
  @override
  void initState() {
    super.initState();

    _refreshEvents(context, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSessionSwitched) {
              _refreshEvents(context, widget.userId);
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
                _refreshEvents(context, widget.userId);
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
              _refreshEvents(context, widget.userId);
            }
          },
        ),
      ],
      child: BlocBuilder<UserEventsBloc, EventsState>(
        builder: (context, state) {
          if (widget.userId == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          else if (state.events.isEmpty) {
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
              _refreshEvents(context, widget.userId);
            },
          );
        },
      ),
    );
  }

  void _loadNextPage(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<UserEventsBloc>().add(LoadEventsNextPage(session: session));
    });
  }

  void _refreshEvents(BuildContext context, int? userId) {
    if (userId == null) return;

    withCurrentSession(context, (session) {
      context.read<UserEventsBloc>().add(
            RefreshUserEvents(
              session: session,
              userId: userId,
            ),
          );
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
        event: event,
        animate: animate,
      ));
    });
  }
}