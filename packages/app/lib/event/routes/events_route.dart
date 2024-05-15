import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_bloc.dart';
import 'package:hollybike/event/bloc/event_event.dart';
import 'package:hollybike/event/bloc/event_state.dart';

import '../../auth/bloc/auth_bloc.dart';

@RoutePage()
class EventsRoute extends StatefulWidget {
  const EventsRoute({super.key});

  @override
  State<EventsRoute> createState() => _EventsRouteState();
}

class _EventsRouteState extends State<EventsRoute> {

  @override
  void initState() {
    super.initState();

    final postsBloc = BlocProvider.of<EventBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    postsBloc.add(LoadEvents(page: 1, session: authBloc.state.currentSession!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSessionSwitched) {
          final session = state.currentSession!;
          context.read<EventBloc>().add(LoadEvents(page: 1, session: session));
        }
      },
      child: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is EventLoadSuccess) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return ListTile(
                  title: Text(event.id.toString()),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
