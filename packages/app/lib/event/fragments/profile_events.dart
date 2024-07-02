import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/event/widgets/events_list/events_sections_list.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';

import '../../app/app_router.gr.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/events_bloc/events_event.dart';
import '../bloc/events_bloc/events_state.dart';
import '../types/minimal_event.dart';

class ProfileEvents extends StatefulWidget {
  final int? userId;
  final GlobalKey<NestedScrollViewState> scrollView;

  const ProfileEvents({
    super.key,
    required this.userId,
    required this.scrollView,
  });

  @override
  State<ProfileEvents> createState() => _ProfileEventsState();
}

class _ProfileEventsState extends State<ProfileEvents> {
  @override
  Widget build(BuildContext context) {
    return ThemedRefreshIndicator(
      onRefresh: () => _refreshEvents(context),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthConnected) {
                _refreshEvents(context);
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
                onEventTap: (event) {
                  _navigateToEventDetails(
                    context,
                    event,
                    true,
                  );
                },
                hasMore: state.hasMore,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshEvents(context);

    final scrollController = widget.scrollView.currentState!.innerController;
    scrollController.addListener(() {
      var nextPageTrigger = 0.8 * scrollController.position.maxScrollExtent;

      if (scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage(context);
      }
    });
  }

  void _loadNextPage(BuildContext context) {
    context.read<UserEventsBloc>().add(LoadEventsNextPage());
  }

  Future<void> _refreshEvents(BuildContext context) {
    context.read<UserEventsBloc>().add(RefreshUserEvents());

    return context.read<UserEventsBloc>().firstWhenNotLoading;
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
