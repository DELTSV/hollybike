import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';

import '../../shared/utils/with_current_session.dart';
import '../bloc/events_bloc/events_event.dart';
import '../types/minimal_event.dart';
import 'events_list_fragment.dart';

class UserEvents extends StatelessWidget {
  final void Function(MinimalEvent) navigateToEventDetails;
  final int? userId;

  const UserEvents({
    super.key,
    required this.userId,
    required this.navigateToEventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return EventsListFragment<UserEventsBloc>(
      navigateToEventDetails: navigateToEventDetails,
      onNextPageRequested: () => _loadNextPage(context),
      onRefreshRequested: () => _refreshEvents(context, userId),
      placeholderText: 'Vous ne participez à aucun événement',
    );
  }

  void _loadNextPage(BuildContext context) {
    withCurrentSession(
      context,
      (session) {
        context.read<UserEventsBloc>().add(
              LoadEventsNextPage(
                session: session,
              ),
            );
      },
    );
  }

  void _refreshEvents(BuildContext context, int? userId) {
    if (userId == null) return;

    withCurrentSession(
      context,
      (session) {
        context.read<UserEventsBloc>().add(
              RefreshUserEvents(
                session: session,
                userId: userId,
              ),
            );
      },
    );
  }
}
