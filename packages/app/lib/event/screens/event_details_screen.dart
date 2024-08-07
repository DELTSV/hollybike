/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/event/fragments/details/event_details_images.dart';
import 'package:hollybike/event/fragments/details/event_details_infos.dart';
import 'package:hollybike/event/fragments/details/event_details_map.dart';
import 'package:hollybike/event/services/participation/event_participation_repository.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/details/event_details_header.dart';
import 'package:hollybike/event/widgets/details/event_edit_floating_button.dart';
import 'package:hollybike/profile/services/profile_repository.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_container.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:provider/provider.dart';

import '../../app/app_router.gr.dart';
import '../../image/services/image_repository.dart';
import '../../positions/bloc/user_positions/user_positions_bloc.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/pinned_header_delegate.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_event.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../bloc/event_images_bloc/event_images_bloc.dart';
import '../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../fragments/details/event_details_my_images.dart';
import '../services/event/event_repository.dart';
import '../types/event_details.dart';
import '../widgets/details/event_details_actions_menu.dart';
import '../widgets/images/show_event_images_picker.dart';

enum EventDetailsTab { info, photos, myPhotos, map }

class Args {
  final MinimalEvent? event;
  final bool animate;

  Args({
    required this.event,
    this.animate = true,
  });
}

@RoutePage()
class EventDetailsScreen extends StatefulWidget implements AutoRouteWrapper {
  final MinimalEvent event;
  final bool animate;
  final String uniqueKey;

  const EventDetailsScreen({
    super.key,
    required this.event,
    this.animate = true,
    this.uniqueKey = "default",
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();

  @override
  Widget wrappedRoute(context) {
    return BlocProvider(
      create: (context) => EventDetailsBloc(
        eventRepository: RepositoryProvider.of<EventRepository>(context),
        eventParticipationRepository:
            RepositoryProvider.of<EventParticipationRepository>(context),
        eventId: event.id,
      )..add(SubscribeToEvent()),
      child: this,
    );
  }
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
    initialIndex: 0,
  );

  late bool _animate = widget.animate;

  late final ScrollController _scrollController = ScrollController();

  EventDetailsTab currentTab = EventDetailsTab.info;

  @override
  void initState() {
    super.initState();

    _tabController.animation?.addListener(() {
      final newTab =
          EventDetailsTab.values[_tabController.animation!.value.round()];

      if (currentTab != newTab) {
        setState(() {
          currentTab = newTab;
        });
      }
    });

    _refreshEventDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailsBloc, EventDetailsState>(
      listener: (context, state) {
        if (state is EventOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventDetailsLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is DeleteEventFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }

        if (state is EventOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }

        if (state is DeleteEventSuccess) {
          Toast.showSuccessToast(context, "Événement supprimé");

          setState(() {
            _animate = false;
          });

          context.router.removeWhere((route) {
            if (route.path == '/event-participations') {
              final eventId = route
                  .argsAs(
                    orElse: () => EventParticipationsRouteArgs(
                      eventDetails: EventDetails.empty(),
                      participationPreview: [],
                    ),
                  )
                  .eventDetails
                  .event
                  .id;

              return eventId == widget.event.id;
            }

            if (route.path == "/event-details") {
              final eventId = route
                  .argsAs(
                    orElse: () => EventDetailsRouteArgs(
                      event: MinimalEvent.empty(),
                    ),
                  )
                  .event
                  .id;

              return eventId == widget.event.id;
            }

            return false;
          });
        }
      },
      child: BlocBuilder<EventDetailsBloc, EventDetailsState>(
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<EventImagesBloc>(
                create: (context) => EventImagesBloc(
                  eventId: widget.event.id,
                  imageRepository: RepositoryProvider.of<ImageRepository>(
                    context,
                  ),
                ),
              ),
              BlocProvider(
                create: (context) => EventMyImagesBloc(
                  eventId: widget.event.id,
                  imageRepository: RepositoryProvider.of<ImageRepository>(
                    context,
                  ),
                  eventRepository: RepositoryProvider.of<EventRepository>(
                    context,
                  ),
                ),
              ),
            ],
            child: Hud(
              appBar: TopBar(
                prefix: TopBarActionIcon(
                  onPressed: () => context.router.maybePop(),
                  icon: Icons.arrow_back,
                ),
                title: const TopBarTitle("Détails"),
                suffix: _renderActions(state),
              ),
              floatingActionButton: _getFloatingButton(),
              body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (
                  BuildContext context,
                  bool innerBoxIsScrolled,
                ) {
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: EventDetailsHeader(
                        event: state.eventDetails?.event.toMinimalEvent() ??
                            widget.event,
                        animate: _animate,
                        uniqueKey: widget.uniqueKey,
                      ),
                    ),
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverPersistentHeader(
                        pinned: true,
                        delegate: PinnedHeaderDelegate(
                          height: 50,
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: TabBar(
                              controller: _tabController,
                              labelColor:
                                  Theme.of(context).colorScheme.secondary,
                              indicatorColor:
                                  Theme.of(context).colorScheme.secondary,
                              tabs: const [
                                Tab(icon: Icon(Icons.info)),
                                Tab(icon: Icon(Icons.photo_library_rounded)),
                                Tab(
                                  icon: Icon(
                                    Icons.add_photo_alternate_rounded,
                                  ),
                                ),
                                Tab(icon: Icon(Icons.explore_rounded)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: _tabTabContent(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tabTabContent() {
    return BlocBuilder<EventDetailsBloc, EventDetailsState>(
      builder: (context, state) {
        if (state.eventDetails == null && state is EventDetailsLoadFailure) {
          return const Center(
            child: Text(
              "Impossible de charger les détails de l'événement",
            ),
          );
        }

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: state.eventDetails == null
              ? const SizedBox()
              : TabBarView(
                  controller: _tabController,
                  children: _getTabs(state.eventDetails!),
                ),
          secondChild: const Center(
            child: CircularProgressIndicator(),
          ),
          crossFadeState:
              state is EventDetailsLoadInProgress && state.eventDetails == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
        );
      },
    );
  }

  List<Widget> _getTabs(
    EventDetails eventDetails,
  ) {
    return [
      ThemedRefreshIndicator(
        onRefresh: _refreshEventDetails,
        child: EventDetailsInfos(
          eventDetails: eventDetails,
          onViewOnMap: () {
            _tabController.animateTo(3);
          },
        ),
      ),
      Builder(builder: (context) {
        return EventDetailsImages(
          scrollController: _scrollController,
          eventId: eventDetails.event.id,
          isParticipating: eventDetails.isParticipating,
          onAddPhotos: () => _onAddPhotoFromAllPhotos(context),
        );
      }),
      EventDetailsMyImages(
        scrollController: _scrollController,
        isParticipating: eventDetails.isParticipating,
        isImagesPublic:
            eventDetails.callerParticipation?.isImagesPublic ?? false,
        eventId: eventDetails.event.id,
      ),
      BlocProvider(
        create: (context) => UserPositionsBloc(
          authPersistence: Provider.of<AuthPersistence>(
            context,
            listen:false
          ),
          profileRepository: RepositoryProvider.of<ProfileRepository>(
            context,
          ),
          canSeeUserPositions: eventDetails.isParticipating,
        ),
        child: EventDetailsMap(
          eventId: eventDetails.event.id,
          journey: eventDetails.journey,
          onMapLoaded: () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    ];
  }

  Future<void> _refreshEventDetails() {
    context.read<EventDetailsBloc>().add(
          LoadEventDetails(),
        );

    return context.read<EventDetailsBloc>().firstWhenNotLoading;
  }

  Widget? _getFloatingButton() {
    switch (currentTab) {
      case EventDetailsTab.info:
        return BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsLoadFailure ||
                (state is EventDetailsLoadInProgress &&
                    state.eventDetails == null) ||
                state.eventDetails == null) {
              return const SizedBox();
            }

            final eventDetails = state.eventDetails!;

            return EventEditFloatingButton(
              canEdit: eventDetails.isOrganizer,
              event: eventDetails.event,
              onEdit: _onEdit,
            );
          },
        );
      case EventDetailsTab.photos:
        return null;
      case EventDetailsTab.myPhotos:
        return BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsLoadFailure ||
                state is EventDetailsLoadInProgress ||
                state.eventDetails == null ||
                state.eventDetails?.isParticipating == false) {
              return const SizedBox();
            }

            final eventDetails = state.eventDetails!;

            return FloatingActionButton.extended(
              onPressed: () => showEventImagesPicker(
                context,
                eventDetails.event.id,
              ),
              label: Text(
                "Ajouter des photos",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              icon: const Icon(Icons.add_a_photo),
            );
          },
        );
      case EventDetailsTab.map:
        return null;
    }
  }

  void _onAddPhotoFromAllPhotos(BuildContext context) {
    _tabController.animateTo(2);

    Future.delayed(const Duration(milliseconds: 500), () {
      showEventImagesPicker(context, widget.event.id);
    });
  }

  Widget? _renderActions(EventDetailsState state) {
    final event = state.eventDetails;

    if ((state is EventDetailsLoadInProgress && event == null) ||
        state is EventDetailsLoadFailure ||
        event == null ||
        (!event.isOwner && !event.isParticipating && !event.isOrganizer)) {
      return null;
    }

    return TopBarActionContainer(
      colorInverted: true,
      child: EventDetailsActionsMenu(
        eventId: event.event.id,
        status: event.event.status,
        isOwner: event.isOwner,
        isJoined: event.isParticipating,
        isOrganizer: event.isOrganizer,
        hasImage: event.event.image != null,
      ),
    );
  }

  void _onEdit(EventFormData formData) {
    context.read<EventDetailsBloc>().add(
          EditEvent(formData: formData),
        );

    Navigator.of(context).pop();
  }
}
