import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/events_bloc/events_state.dart';
import '../bloc/events_bloc/future_events_bloc.dart';
import '../widgets/events_list/events_list.dart';

class EventsListFragment<T extends EventsBloc> extends StatefulWidget {
  final void Function() onNextPageRequested;
  final Future<void> Function() onRefreshRequested;
  final String placeholderText;

  const EventsListFragment({
    super.key,
    required this.onNextPageRequested,
    required this.onRefreshRequested,
    required this.placeholderText,
  });

  @override
  State<EventsListFragment> createState() => _EventsListFragmentState<T>();
}

class _EventsListFragmentState<T extends EventsBloc>
    extends State<EventsListFragment> {
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
            if (state is AuthConnected) {
              widget.onRefreshRequested();
            }
          },
        ),
        BlocListener<FutureEventsBloc, EventsState>(listener: (context, state) {
          if (state is EventCreationSuccess) {
            Future.delayed(
              const Duration(milliseconds: 200),
              widget.onRefreshRequested,
            );
          }
        }),
      ],
      child: ThemedRefreshIndicator(
        onRefresh: widget.onRefreshRequested,
        child: BlocBuilder<T, EventsState>(
          builder: (context, state) {
            if (state.events.isEmpty) {
              return _buildPlaceholder(context, state);
            }

            return EventsList(
              hasMore: state.hasMore,
              events: state.events,
              onNextPageRequested: widget.onNextPageRequested,
              onRefreshRequested: widget.onRefreshRequested,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, EventsState state) {
    switch (state.status) {
      case EventStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case EventStatus.error:
        return EventsListPlaceholder(
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
        return EventsListPlaceholder(
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
                widget.placeholderText,
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
}
