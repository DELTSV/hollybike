import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_bloc.dart';
import 'package:hollybike/event/bloc/event_state.dart';
import 'package:hollybike/event/widgets/event_image.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../bloc/event_event.dart';

@RoutePage()
class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.eventImage,
  });

  final int eventId;
  final EventImage eventImage;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();

    withCurrentSession(context, (session) {
      context.read<EventBloc>().add(
            LoadEventDetails(
              eventId: widget.eventId,
              session: session,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Hero(
              tag: widget.eventId,
              child: Container(
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: widget.eventImage,
              ),
            ),
          ),
          BlocBuilder<EventBloc, EventState>(builder: (context, state) {
            if (state is EventLoadSuccess) {
              if (state.event == null) {
                return const Text("Event not found");
              }

              return Column(
                children: [
                  Text(state.event!.name),
                  Text(state.event!.startDate.toString()),
                ],
              );
            }

            return const CircularProgressIndicator();
          }),
        ],
      ),
    );
  }
}
