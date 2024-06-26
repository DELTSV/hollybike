import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';
import 'package:provider/provider.dart';

import '../bloc/events_bloc/events_event.dart';
import '../types/minimal_event.dart';
import 'events_list_fragment.dart';

class UserEvents extends StatelessWidget {
  final void Function(MinimalEvent) navigateToEventDetails;

  const UserEvents({
    super.key,
    required this.navigateToEventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvidedBuilder<ProfileBloc, ProfileState>(
      builder: (context, bloc, state) {
        if (bloc.currentProfile == null) return const Text("loading");

        return EventsListFragment<UserEventsBloc>(
          navigateToEventDetails: navigateToEventDetails,
          onNextPageRequested: () => _loadNextPage(context),
          onRefreshRequested: () =>
              _refreshEvents(context, bloc.currentProfile!.id),
          placeholderText: 'Vous ne participez à aucun événement',
        );
      },
    );
  }

  void _loadNextPage(BuildContext context) {
    context.read<UserEventsBloc>().add(
      LoadEventsNextPage(),
    );
  }

  Future<void> _refreshEvents(BuildContext context, int? userId) {
    if (userId == null) return Future.value();

    context.read<UserEventsBloc>().add(
      RefreshUserEvents(
        userId: userId,
      ),
    );

    return context.read<UserEventsBloc>().firstWhenNotLoading;
  }
}
