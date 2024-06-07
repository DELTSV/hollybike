import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/event_image.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../app/app_router.gr.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../shared/utils/dates.dart';
import '../../shared/widgets/app_toast.dart';
import '../bloc/events_bloc/events_event.dart';
import '../bloc/events_bloc/events_state.dart';
import '../widgets/event_form/event_form_modal.dart';
import '../widgets/event_preview_card.dart';

@RoutePage()
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _loadNextPage();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _loadNextPage() {
    withCurrentSession(context, (session) {
      context.read<EventsBloc>().add(LoadEventsNextPage(session: session));
    });
  }

  void _refreshEvents() {
    withCurrentSession(context, (session) {
      context.read<EventsBloc>().add(RefreshEvents(session: session));
    });
  }

  void _navigateToEventDetails(
    BuildContext context,
    MinimalEvent event,
    bool animate,
  ) {
    // delay 200 ms to allow the animation to finish
    Future.delayed(const Duration(milliseconds: 200), () {
      context.router.push(EventDetailsRoute(
        eventId: event.id,
        eventImage: EventImage(event: event),
        eventName: event.name,
        animate: animate,
      ));
    });
  }

  Widget getPreviewWithColumn(MinimalEvent event, bool showHeader) {
    final previewCard = EventPreviewCard(
      event: event,
      onTap: () {
        _navigateToEventDetails(context, event, true);
      },
    );

    if (!showHeader) {
      return previewCard;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          getMonthWithDistantYear(event.startDate),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        previewCard,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hud(
      displayNavBar: true,
      appBar: const TopBar(
        title: TopBarTitle('Événements'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Timer(const Duration(milliseconds: 100), () {
            showModalBottomSheet<void>(
              context: context,
              enableDrag: false,
              builder: (BuildContext context) {
                return EventFormModal(
                  onSubmit: (formData) {
                    withCurrentSession(context, (session) {
                      context.read<EventsBloc>().add(
                            CreateEvent(
                              session: session,
                              formData: formData,
                            ),
                          );
                    });

                    Navigator.of(context).pop();
                  },
                  submitButtonText: 'Créer',
                );
              },
            );
          });
        },
        label: Text(
          'Ajouter',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        icon: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          _refreshEvents();
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSessionSwitched) {
                  _refreshEvents();
                }
              },
            ),
            BlocListener<EventsBloc, EventsState>(listener: (context, state) {
              if (state is EventCreationSuccess) {
                Toast.showSuccessToast(context, "Événement créé");

                Future.delayed(const Duration(milliseconds: 50), () {
                  _navigateToEventDetails(
                      context, state.createdEvent.toMinimalEvent(), false);

                  Future.delayed(const Duration(milliseconds: 200), () {
                    _refreshEvents();
                  });
                });
              }

              if (state is EventCreationFailure) {
                Toast.showErrorToast(context, state.errorMessage);
              }
            }),
            BlocListener<EventDetailsBloc, EventDetailsState>(
                listener: (context, state) {
              if (state is DeleteEventSuccess) {
                Toast.showSuccessToast(context, "Événement supprimé");
                _refreshEvents();
              }
            }),
          ],
          child: BlocBuilder<EventsBloc, EventsState>(
            builder: (context, state) {
              if (state.events.isEmpty) {
                switch (state.status) {
                  case EventStatus.initial:
                    return const SizedBox();
                  case EventStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case EventStatus.error:
                    return const Center(
                      child: Text('Oups, une erreur est survenue.'),
                    );
                  case EventStatus.success:
                    return const Center(
                      child: Text('Aucun post trouvé.'),
                    );
                }
              }

              return Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: state.events.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.events.length) {
                      if (state.status == EventStatus.error) {
                        return const Center(
                          child: Text('Oups, une erreur est survenue.'),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }

                    final event = state.events[index];

                    final columnWithHeader = getPreviewWithColumn(
                      event,
                      index == 0 ||
                          event.startDate.month !=
                              state.events[index - 1].startDate.month,
                    );

                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(50 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: columnWithHeader,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
