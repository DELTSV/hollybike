import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/widgets/event_image.dart';
import 'package:hollybike/event/widgets/event_participations_preview.dart';
import 'package:hollybike/event/widgets/event_pending_warning.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../app/app_router.gr.dart';
import '../../shared/widgets/app_toast.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_event.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../bloc/events_bloc/events_bloc.dart';
import '../types/event_participation.dart';
import '../widgets/event_form/event_form_modal.dart';

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
    return BlocBuilder<EventDetailsBloc, EventDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Détails"),
            actions: [
              Builder(
                builder: (context) {
                  if (state is EventDetailsLoadInProgress) {
                    return const SizedBox();
                  }

                  if (state is EventDetailsLoadFailure) {
                    return const SizedBox();
                  }

                  if (state.eventDetails == null) {
                    return const SizedBox();
                  }

                  final Event event = state.eventDetails!.event;

                  return PopupMenuButton(itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: "quit",
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app),
                            SizedBox(width: 10),
                            Text("Quitter l'événement"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 10),
                            Text("Supprimer l'événement"),
                          ],
                        ),
                      ),
                    ];
                  }, onSelected: (value) {
                    if (value == "delete") {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Supprimer l'événement"),
                            content: const Text("Êtes-vous sûr de vouloir supprimer cet événement ?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () {
                                  withCurrentSession(context, (session) {
                                    // context.read<EventsBloc>().add(
                                    //       DeleteEvent(
                                    //         eventId: event.id,
                                    //         session: session,
                                    //       ),
                                    //     );
                                  });

                                  Navigator.of(context).pop();
                                },
                                child: const Text("Supprimer"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                },
              ),
            ],
          ),
          floatingActionButton: Builder(
            builder: (context) {
              void Function()? onPressed = () {
                Timer(const Duration(milliseconds: 100), () {
                  showModalBottomSheet<void>(
                    context: context,
                    enableDrag: false,
                    builder: (BuildContext context) {
                      return EventFormModal(
                        initialData: EventFormData(
                          name: state.eventDetails?.event.name ?? "",
                          description: state.eventDetails?.event.description,
                          startDate: state.eventDetails?.event.startDate ?? DateTime.now(),
                          endDate: state.eventDetails?.event.endDate,
                        ),
                        onSubmit: (formData) {
                          withCurrentSession(context, (session) {
                            print(formData.name);
                            print(formData.description);
                            print(formData.startDate);
                            print(formData.endDate);
                            // context.read<EventsBloc>().add(
                            //   CreateEvent(
                            //     session: session,
                            //     name: name,
                            //     description: description,
                            //     startDate: startDate,
                            //     endDate: endDate,
                            //   ),
                            // );
                          });

                          Navigator.of(context).pop();
                        },
                        submitButtonText: 'Sauvegarder',
                      );
                    },
                  );
                });
              };

              if (state is EventDetailsLoadInProgress || state.eventDetails?.event == null) {
                onPressed = null;
              }

              if (state is EventDetailsLoadFailure) {
                return const SizedBox();
              }

              return FloatingActionButton.extended(
                onPressed: onPressed,
                label: Text(
                  'Modifier',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                icon: const Icon(Icons.edit),
              );
            },
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
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
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
                  Builder(builder: (context) {
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

                    List<Widget> children = [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          EventParticipationsPreview(
                            event: event,
                            previewParticipants: previewParticipants,
                            previewParticipantsCount: previewParticipantsCount,
                            onTap: () {
                              Timer(const Duration(milliseconds: 100), () {
                                context.router.push(
                                  EventParticipationsRoute(
                                    eventId: event.id,
                                    participationPreview: previewParticipants,
                                  ),
                                );
                              });
                            },
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
      },
    );
  }
}
