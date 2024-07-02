import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';

import '../bloc/events_bloc/events_event.dart';
import '../bloc/events_bloc/future_events_bloc.dart';
import '../types/minimal_event.dart';
import 'events_list_fragment.dart';

class FutureEvents extends StatelessWidget {
  final void Function(MinimalEvent) navigateToEventDetails;

  const FutureEvents({
    super.key,
    required this.navigateToEventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return EventsListFragment<FutureEventsBloc>(
      navigateToEventDetails: navigateToEventDetails,
      onNextPageRequested: () => _loadNextPage(context),
      onRefreshRequested: () => _refreshEvents(context),
      placeholderText: 'Aucun événement à venir',
    );
  }

  void _loadNextPage(BuildContext context) {
    context
        .read<FutureEventsBloc>()
        .add(LoadEventsNextPage());
  }

  Future<void> _refreshEvents(BuildContext context) {
    context.read<FutureEventsBloc>().add(RefreshEvents());

    return context.read<FutureEventsBloc>().firstWhenNotLoading;
  }
}
