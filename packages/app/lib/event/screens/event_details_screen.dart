import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/widgets/event_image.dart';
import 'package:hollybike/event/widgets/event_pending_warning.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../app/app_router.gr.dart';
import '../../shared/widgets/app_toast.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_event.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../types/event_participation.dart';

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

  Widget _getParticipantsText(int count, int totalCount) {
    if (totalCount == 1) {
      return Text(
        "1 participant",
        style: Theme.of(context).textTheme.titleSmall,
      );
    }

    if (totalCount > 5) {
      return Text(
        "+ ${totalCount - 5}",
        style: Theme.of(context).textTheme.titleSmall,
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails"),
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
          'Modifier',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        icon: const Icon(Icons.edit),
      ),
      body: BlocListener<EventDetailsBloc, EventDetailsState>(
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

                if (state.eventDetails == null) {
                  return const Text("Event not found");
                }

                final Event event = state.eventDetails!.event;
                final List<EventParticipation> previewParticipants =
                    state.eventDetails!.previewParticipants;

                final int previewParticipantsCount =
                    state.eventDetails!.previewParticipantsCount;

                const avatarSize = 43.0;
                const avatarRadius = avatarSize / 2;
                const borderSize = 4.0;

                List<Widget> children = [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        height: avatarSize + 12,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: avatarSize,
                                    width: (previewParticipants.length *
                                            avatarRadius) +
                                        avatarRadius,
                                    child: Stack(
                                      alignment: Alignment.topLeft,
                                      children: previewParticipants
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final participation = entry.value;
                                        final index = entry.key;

                                        final avatar = Container(
                                          width: avatarSize,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              width: borderSize,
                                            ),
                                          ),
                                          child: Hero(
                                            tag: "profile_picture_participation_${participation.user.id}",
                                            child: CircleAvatar(
                                              radius: avatarRadius,
                                              backgroundImage: participation
                                                          .user.profilePicture !=
                                                      null
                                                  ? Image.network(
                                                      participation
                                                          .user.profilePicture!,
                                                    ).image
                                                  : Image.asset(
                                                          "assets/images/placeholder_profile_picture.jpg")
                                                      .image,
                                            ),
                                          ),
                                        );

                                        if (index == 0) {
                                          return avatar;
                                        }

                                        return Positioned(
                                          top: -borderSize,
                                          left: avatarRadius * index.toDouble(),
                                          child: avatar,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _getParticipantsText(
                                    previewParticipants.length,
                                    previewParticipantsCount,
                                  ),
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    context.router.push(
                                      EventParticipationsRoute(
                                        eventId: event.id,
                                        participationPreview: previewParticipants,
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print("Rejoindre");
                        },
                        child: const Text("Rejoindre"),
                      ),
                    ],
                  ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
