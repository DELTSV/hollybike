import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_state.dart';
import 'package:hollybike/event/types/event_participation.dart';

import '../../shared/utils/with_current_session.dart';

@RoutePage()
class EventParticipationsScreen extends StatefulWidget {
  final int eventId;
  final List<EventParticipation> participationPreview;

  const EventParticipationsScreen({
    super.key,
    required this.eventId,
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
                eventId: widget.eventId,
                session: session,
              ),
            );
      },
    );
  }

  Widget _buildList(List<EventParticipation> participants) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: participants.length,
      separatorBuilder: (context, index) =>
      const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final participation = participants[index];
        return Row(
          key: ValueKey(participation.user.id),
          children: [
            Hero(
              tag:
              "profile_picture_participation_${participation.user.id}",
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                participation.user.profilePicture != null
                    ? Image.network(
                  participation.user.profilePicture!,
                ).image
                    : Image.asset(
                  "assets/images/placeholder_profile_picture.jpg",
                ).image,
              ),
            ),
            Text(
              participation.user.username,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
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
          // Timer(const Duration(milliseconds: 100), () {
          //   showModalBottomSheet<void>(
          //     context: context,
          //     enableDrag: false,
          //     builder: (BuildContext context) {
          //       return const EventCreationModal();
          //     },
          //   );
          // });
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
              if (state is EventParticipationsPageLoadInProgress) {
                return _buildList(widget.participationPreview);
              }

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
}
