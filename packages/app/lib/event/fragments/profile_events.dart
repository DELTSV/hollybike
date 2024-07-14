import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
import 'package:hollybike/event/widgets/events_list/events_sections_list.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

import '../bloc/events_bloc/events_event.dart';
import '../bloc/events_bloc/events_state.dart';

class ProfileEvents extends StatefulWidget {
  final bool isMe;
  final String username;
  final ScrollController scrollController;

  const ProfileEvents({
    super.key,
    required this.isMe,
    required this.username,
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
      child: BlocBuilder<UserEventsBloc, EventsState>(
        builder: (context, state) {
          if (state.events.isEmpty) {
            return _buildPlaceholder(context, state.status);
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
    );
  }

  Widget _buildPlaceholder(BuildContext context, EventStatus status) {
    switch (status) {
      case EventStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case EventStatus.error:
        return ScrollablePlaceholder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MediaQuery.of(context).size.width * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                fit: BoxFit.cover,
                'assets/lottie/lottie_calendar_error_animation.json',
                repeat: false,
              ),
              const SizedBox(height: 16),
              Text(
                'Une erreur est survenue lors du chargement des évènements',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case EventStatus.success:
        return ScrollablePlaceholder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                fit: BoxFit.cover,
                'assets/lottie/lottie_calendar_placeholder.json',
                repeat: false,
              ),
              const SizedBox(height: 16),
              Text(
                widget.isMe
                    ? 'Vous ne participez à aucun évènement'
                    : '${widget.username} ne participe à aucun évènement',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
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
