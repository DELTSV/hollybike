import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_bloc.dart';
import 'package:hollybike/event/bloc/event_event.dart';
import 'package:hollybike/event/bloc/event_state.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../widgets/event_preview_card.dart';

@RoutePage()
class EventsRoute extends StatefulWidget {
  const EventsRoute({super.key});

  @override
  State<EventsRoute> createState() => _EventsRouteState();
}

class _EventsRouteState extends State<EventsRoute> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _loadNextPage();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _loadNextPage() {
    withCurrentSession(context, (session) {
      context.read<EventBloc>().add(LoadEventsNextPage(session: session));
    });
  }

  void _refreshEvents() {
    withCurrentSession(context, (session) {
      context.read<EventBloc>().add(RefreshEvents(session: session));
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      backgroundColor: const Color(0xff1E2A47),
      color: Colors.white,
      onRefresh: () async {
        _refreshEvents();
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSessionSwitched) {
            _refreshEvents();
          }
        },
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            // if (state is EventLoadInProgress) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

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
                    child: Text('Aucun post trouvé.'),
                  );
              }
            }

            return ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: state.events.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.events.length) {
                  if (state.status == EventStatus.error) {
                    return const Center(
                      child: Text('Oups, une erreur est survenue.'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }

                final event = state.events[index];

                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(50 * (1 - value), 0),
                      child: Opacity(
                        opacity: value,
                        child: EventPreviewCard(event: event),
                      ),
                    );
                  }
                );
              },
            );
          },
        ),
      ),
    );
  }
}
