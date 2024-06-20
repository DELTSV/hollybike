import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/event/widgets/events_list/events_sections_list.dart';

import '../../app/app_router.gr.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../shared/utils/with_current_session.dart';
import '../../shared/widgets/app_toast.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
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
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () => _refreshEvents(context, widget.userId),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSessionSwitched) {
                _refreshEvents(context, widget.userId);
              }
            },
          ),
          BlocListener<EventDetailsBloc, EventDetailsState>(
            listener: (context, state) {
              if (state is DeleteEventSuccess) {
                Toast.showSuccessToast(context, "Événement supprimé");
                _refreshEvents(context, widget.userId);
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
    _refreshEvents(context, widget.userId);

    final scrollController = widget.scrollView.currentState!.innerController;
    scrollController.addListener(() {
      var nextPageTrigger = 0.8 * scrollController.position.maxScrollExtent;

      if (scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage(context);
      }
    });
  }

  void _loadNextPage(BuildContext context) {
    withCurrentSession(context, (session) {
      context.read<UserEventsBloc>().add(LoadEventsNextPage(session: session));
    });
  }

  Future<void> _refreshEvents(BuildContext context, int? userId) {
    if (userId == null) return Future.value();

    withCurrentSession(context, (session) {
      context.read<UserEventsBloc>().add(
            RefreshUserEvents(
              session: session,
              userId: userId,
            ),
          );
    });

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
