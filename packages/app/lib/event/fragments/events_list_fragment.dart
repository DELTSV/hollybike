import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../bloc/events_bloc/events_state.dart';
import '../bloc/events_bloc/future_events_bloc.dart';
import '../types/minimal_event.dart';
import '../widgets/events_list/events_list.dart';

class EventsListFragment<T extends EventsBloc> extends StatefulWidget {
  final void Function(MinimalEvent) navigateToEventDetails;
  final void Function() onNextPageRequested;
  final void Function() onRefreshRequested;

  const EventsListFragment({
    super.key,
    required this.navigateToEventDetails,
    required this.onNextPageRequested,
    required this.onRefreshRequested,
  });

  @override
  State<EventsListFragment> createState() => _EventsListFragmentState<T>();
}

class _EventsListFragmentState<T extends EventsBloc> extends State<EventsListFragment> {
  @override
  void initState() {
    super.initState();

    widget.onRefreshRequested();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSessionSwitched) {
              widget.onRefreshRequested();
            }
          },
        ),
        BlocListener<FutureEventsBloc, EventsState>(listener: (context, state) {
          if (state is EventCreationSuccess) {
            Future.delayed(const Duration(milliseconds: 200), () {
              widget.onRefreshRequested();
            });
          }
        }),
        BlocListener<EventDetailsBloc, EventDetailsState>(
          listener: (context, state) {
            if (state is DeleteEventSuccess || state is LeaveEventSuccess) {
              widget.onRefreshRequested();
            }
          },
        ),
      ],
      child: BlocBuilder<T, EventsState>(
        builder: (context, state) {
          if (state.events.isEmpty) {
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
                  child: Text('Aucun event trouvé.'),
                );
            }
          }

          return EventsList(
            hasMore: state.hasMore,
            events: state.events,
            onNextPageRequested: widget.onNextPageRequested,
            onEventTap: widget.navigateToEventDetails,
            onRefreshRequested: widget.onRefreshRequested,
          );
        },
      ),
    );
  }
}
