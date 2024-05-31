import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_state.dart';
import 'package:hollybike/event/types/event.dart';

import '../bloc/event_details_bloc/event_details_state.dart';

class EventParticipationsPreview extends StatefulWidget {
  final Event event;

  const EventParticipationsPreview({super.key, required this.event});

  @override
  State<EventParticipationsPreview> createState() =>
      _EventParticipationsPreviewState();
}

class _EventParticipationsPreviewState
    extends State<EventParticipationsPreview> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventParticipationBloc, EventParticipationsState>(
      builder: (context, state) {
        if (state is EventParticipationsPreviewLoadInProgress) {
          return Container();
        }

        if (state is EventParticipationsPreviewLoadFailure) {
          return Container();
        }

        return Row(
          children: [
            Text('Participants: ${state.participants.length}'),
            Text('Remaining participants: ${state}'),
          ],
        );
      },
    );
  }
}
