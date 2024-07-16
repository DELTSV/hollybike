/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/archived_events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';

import '../bloc/events_bloc/events_event.dart';
import '../services/event/event_repository.dart';
import 'events_list_fragment.dart';

class ArchivedEvents extends StatelessWidget {

  const ArchivedEvents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArchivedEventsBloc>(
        create: (context) => ArchivedEventsBloc(
              eventRepository: RepositoryProvider.of<EventRepository>(context),
            )..add(SubscribeToEvents()),
        child: Builder(
          builder: (context) {
            return EventsListFragment<ArchivedEventsBloc>(
              onNextPageRequested: () => _loadNextPage(context),
              onRefreshRequested: () => _refreshEvents(context),
              placeholderText: 'Aucun événement archivé',
            );
          },
        ));
  }

  void _loadNextPage(BuildContext context) {
    context.read<ArchivedEventsBloc>().add(LoadEventsNextPage());
  }

  Future<void> _refreshEvents(BuildContext context) {
    context.read<ArchivedEventsBloc>().add(RefreshEvents());

    return context.read<ArchivedEventsBloc>().firstWhenNotLoading;
  }
}
