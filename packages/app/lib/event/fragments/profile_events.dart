import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/event/widgets/events_list/events_sections_list.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/events_bloc/events_event.dart';
import '../bloc/events_bloc/events_state.dart';

class ProfileEvents extends StatefulWidget {
  final int? userId;
  final ScrollController scrollController;

  const ProfileEvents({
    super.key,
    required this.userId,
    required this.scrollController,
  });

  @override
  State<ProfileEvents> createState() => _ProfileEventsState();
}

class _ProfileEventsState extends State<ProfileEvents> {
  @override
  void initState() {
    super.initState();
    _refreshEvents();
    widget.scrollController.addListener(_listenToScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listenToScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedRefreshIndicator(
      onRefresh: () => _refreshEvents(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthConnected) {
                _refreshEvents();
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

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EventsSectionsList(
                events: state.events,
                hasMore: state.hasMore,
                physics: const ClampingScrollPhysics(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _listenToScroll() {
    var nextPageTrigger =
        0.8 * widget.scrollController.position.maxScrollExtent;

    if (widget.scrollController.position.pixels > nextPageTrigger) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    context.read<UserEventsBloc>().add(LoadEventsNextPage());
  }

  Future<void> _refreshEvents() {
    context.read<UserEventsBloc>().add(RefreshUserEvents());

    return context.read<UserEventsBloc>().firstWhenNotLoading;
  }
}
