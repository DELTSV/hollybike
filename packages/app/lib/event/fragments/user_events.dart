import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../bloc/events_bloc/events_event.dart';
import '../services/event/event_repository.dart';
import 'events_list_fragment.dart';

class UserEvents extends StatelessWidget {
  const UserEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvidedBuilder<ProfileBloc, ProfileState>(
      builder: (context, bloc, state) {
        final currentProfile = bloc.currentProfile;
        if (currentProfile is! ProfileLoadSuccessEvent) return const Text("loading");

        return BlocProvider<UserEventsBloc>(
          create: (context) => UserEventsBloc(
            eventRepository: RepositoryProvider.of<EventRepository>(context),
            userId: currentProfile.profile.id,
          )..add(SubscribeToEvents()),
          child: Builder(
            builder: (context) {
              return EventsListFragment<UserEventsBloc>(
                onNextPageRequested: () => _loadNextPage(context),
                onRefreshRequested: () => _refreshEvents(context),
                placeholderText: 'Vous ne participez à aucun événement',
              );
            },
          ),
        );
      },
    );
  }

  void _loadNextPage(BuildContext context) {
    context.read<UserEventsBloc>().add(
          LoadEventsNextPage(),
        );
  }

  Future<void> _refreshEvents(BuildContext context) {
    context.read<UserEventsBloc>().add(
          RefreshUserEvents(),
        );

    return context.read<UserEventsBloc>().firstWhenNotLoading;
  }
}
