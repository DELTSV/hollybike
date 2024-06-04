import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_state.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_participation.dart';

import '../../shared/utils/with_current_session.dart';
import '../widgets/participations/event_participation_card.dart';

@RoutePage()
class EventParticipationsScreen extends StatefulWidget {
  final EventDetails eventDetails;
  final List<EventParticipation> participationPreview;

  const EventParticipationsScreen({
    super.key,
    required this.eventDetails,
    required this.participationPreview,
  });

  @override
  State<EventParticipationsScreen> createState() =>
      _EventParticipationsScreenState();
}

class _EventParticipationsScreenState extends State<EventParticipationsScreen> {
  @override
  void initState() {
    super.initState();

    withCurrentSession(
      context,
      (session) {
        context.read<EventParticipationBloc>().add(
              RefreshEventParticipations(
                eventId: widget.eventDetails.event.id,
                participationPreview: widget.participationPreview,
                session: session,
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Participants"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Container(),
              );
            },
          );
        },
        label: Text(
          'Ajouter',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        icon: const Icon(Icons.edit),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: BlocBuilder<EventParticipationBloc, EventParticipationsState>(
            builder: (context, state) {
              if (state is EventParticipationsPageLoadFailure) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }

              return _buildList(state.participants);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<EventParticipation> participants) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: participants.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final participation = participants[index];
        return EventParticipationCard(
          participation: participation,
          isOwner: widget.eventDetails.event.owner.id == participation.user.id,
          isCurrentUser: participation.user.id == widget.eventDetails.callerParticipation?.userId,
          isCurrentUserOrganizer: widget.eventDetails.isOrganizer,
        );
      },
    );
  }
}
