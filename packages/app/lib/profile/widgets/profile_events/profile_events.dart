import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/profile/widgets/profile_events/profile_events_list.dart';

import '../../../app/app_router.gr.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../event/bloc/event_details_bloc/event_details_bloc.dart';
import '../../../event/bloc/event_details_bloc/event_details_state.dart';
import '../../../event/bloc/events_bloc/events_event.dart';
import '../../../event/bloc/events_bloc/events_state.dart';
import '../../../event/types/minimal_event.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../../shared/widgets/app_toast.dart';

class ProfileEvents extends StatefulWidget {
  final int? userId;

  const ProfileEvents({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileEvents> createState() => _ProfileEventsState();
}

class _ProfileEventsState extends State<ProfileEvents> {
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
          } else if (state.events.isEmpty) {
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

          return ProfileEventsList(
            events: state.events,
            onEventTap: (event) {
              _navigateToEventDetails(
                context,
                event,
                true,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshEvents(context, widget.userId);
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
