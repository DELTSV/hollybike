import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_bloc.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_event.dart';

import '../../shared/utils/with_current_session.dart';

@RoutePage()
class EventCandidatesScreen extends StatefulWidget {
  final int eventId;

  const EventCandidatesScreen({super.key, required this.eventId});

  @override
  State<EventCandidatesScreen> createState() => _EventCandidatesScreenState();
}

class _EventCandidatesScreenState extends State<EventCandidatesScreen> {
  @override
  void initState() {
    super.initState();

    _refreshCandidates();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void _refreshCandidates() {
    withCurrentSession(
      context,
      (session) {
        context.read<EventCandidatesBloc>().add(
              RefreshEventCandidates(
                eventId: widget.eventId,
                session: session,
              ),
            );
      },
    );
  }
}
