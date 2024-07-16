/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';

import '../bloc/events_bloc/events_event.dart';
import '../bloc/events_bloc/future_events_bloc.dart';
import 'events_list_fragment.dart';

class FutureEvents extends StatelessWidget {
  const FutureEvents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EventsListFragment<FutureEventsBloc>(
      onNextPageRequested: () => _loadNextPage(context),
      onRefreshRequested: () => _refreshEvents(context),
      placeholderText: 'Aucun événement à venir',
    );
  }

  void _loadNextPage(BuildContext context) {
    context.read<FutureEventsBloc>().add(LoadEventsNextPage());
  }

  Future<void> _refreshEvents(BuildContext context) {
    context.read<FutureEventsBloc>().add(RefreshEvents());

    return context.read<FutureEventsBloc>().firstWhenNotLoading;
  }
}
