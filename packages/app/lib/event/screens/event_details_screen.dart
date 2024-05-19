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
    required this.eventName,
  });

  final int eventId;
  final EventImage eventImage;
  final String eventName;

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
            child: Stack(
              children: [
                Hero(
                  tag: "event-image-${widget.eventId}",
                  child: Container(
                    width: double.infinity,
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Hero(
                              tag: "event-name-${widget.eventId}",
                              child: SizedBox(
                                width: constraints.maxWidth - 20,
                                child: Text(
                                  widget.eventName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<EventBloc, EventState>(builder: (context, state) {
            if (state is EventLoadSuccess) {
              if (state.event == null) {
                return const Text("Event not found");
              }

              return Column(
                children: [
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
