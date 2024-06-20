import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/archived_events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';

import '../../shared/utils/with_current_session.dart';
import '../bloc/events_bloc/events_event.dart';
import '../types/minimal_event.dart';
import 'events_list_fragment.dart';

class ArchivedEvents extends StatelessWidget {
  final void Function(MinimalEvent) navigateToEventDetails;

  const ArchivedEvents({
    super.key,
    required this.navigateToEventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return EventsListFragment<ArchivedEventsBloc>(
      navigateToEventDetails: navigateToEventDetails,
      onNextPageRequested: () => _loadNextPage(context),
      onRefreshRequested: () => _refreshEvents(context),
      placeholderText: 'Aucun événement archivé',
    );
  }

  void _loadNextPage(BuildContext context) {
    withCurrentSession(context, (session) {
      context
          .read<ArchivedEventsBloc>()
          .add(LoadEventsNextPage(session: session));
    });
  }

  Future<void> _refreshEvents(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<ArchivedEventsBloc>().add(RefreshEvents(session: session));
    });

    return context.read<ArchivedEventsBloc>().firstWhenNotLoading;
  }
}
