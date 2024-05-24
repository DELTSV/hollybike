import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_state.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/widgets/event_image.dart';
import 'package:hollybike/event/widgets/event_pending_warning.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../shared/widgets/app_toast.dart';
import '../bloc/event_details_event.dart';

@RoutePage()
class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.eventImage,
    required this.eventName,
    this.animate = true,
  });

  final int eventId;
  final EventImage eventImage;
  final String eventName;
  final bool animate;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();

    withCurrentSession(
      context,
      (session) {
        context.read<EventDetailsBloc>().add(
              LoadEventDetails(
                eventId: widget.eventId,
                session: session,
              ),
            );
      },
    );
  }

  void _onPublish() {
    withCurrentSession(
      context,
      (session) {
        context.read<EventDetailsBloc>().add(
              PublishEvent(
                eventId: widget.eventId,
                session: session,
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailsBloc, EventDetailsState>(
      listener: (context, state) {
        if (state is EventOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }

        if (state is EventOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                children: [
                  HeroMode(
                    enabled: widget.animate,
                    child: Hero(
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
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HeroMode(
                              enabled: widget.animate,
                              child: Hero(
                                tag: "event-name-${widget.eventId}",
                                child: SizedBox(
                                  width: constraints.maxWidth - 20,
                                  child: Text(
                                    widget.eventName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<EventDetailsBloc, EventDetailsState>(builder: (
              context,
              state,
            ) {
              if (state is EventDetailsLoadInProgress) {
                return const CircularProgressIndicator();
              }

              if (state is EventDetailsLoadFailure) {
                return const Text("Error while loading event details");
              }

              if (state.event == null) {
                return const Text("Event not found");
              }

              final Event event = state.event!;

              List<Widget> children = [
                Text(event.startDate.toString()),
              ];

              if (event.status == EventStatusState.pending) {
                children.insert(
                  0,
                  EventPendingWarning(
                    onAction: () => {
                      _onPublish(),
                    },
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: children,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
