import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/fragments/details/event_details_images.dart';
import 'package:hollybike/event/fragments/details/event_details_infos.dart';
import 'package:hollybike/event/fragments/details/event_details_map.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/details/event_details_header.dart';
import 'package:hollybike/event/widgets/details/event_edit_floating_button.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_container.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../positions/bloc/user_positions_bloc.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/pinned_header_delegate.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_event.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../fragments/details/event_details_my_images.dart';
import '../types/event_details.dart';
import '../widgets/details/event_details_actions_menu.dart';
import '../widgets/images/show_event_images_picker.dart';

enum EventDetailsTab { info, photos, myPhotos, map }

@RoutePage()
class EventDetailsScreen extends StatefulWidget {
  final MinimalEvent event;
  final bool animate;

  const EventDetailsScreen({
    super.key,
    required this.event,
    this.animate = true,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  var eventName = "";

  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
    initialIndex: 0,
  );

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

    setState(() {
      eventName = widget.event.name;
    });

    _loadEventDetails();
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
          context.router.maybePop();
        }

        setState(() {
          eventName = state.eventDetails?.event.name ?? widget.event.name;
        });
      },
      child: Hud(
        appBar: BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            return TopBar(
              prefix: TopBarActionIcon(
                onPressed: () => context.router.maybePop(),
                icon: Icons.arrow_back,
              ),
              title: const TopBarTitle("Détails"),
              suffix: _renderActions(state),
            );
          },
        ),
        floatingActionButton: _getFloatingButton(),
        body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                SliverToBoxAdapter(
                  child: EventDetailsHeader(
                    event: widget.event,
                    animate: widget.animate,
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
                          labelColor: Theme.of(context).colorScheme.secondary,
                          indicatorColor:
                              Theme.of(context).colorScheme.secondary,
                          tabs: const [
                            Tab(icon: Icon(Icons.info)),
                            Tab(icon: Icon(Icons.photo_library)),
                            Tab(icon: Icon(Icons.image)),
                            Tab(icon: Icon(Icons.map)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: BlocBuilder<EventDetailsBloc, EventDetailsState>(
              builder: (context, state) {
                if (state is EventDetailsLoadInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.eventDetails == null ||
                    state is EventDetailsLoadFailure) {
                  return const Center(
                    child: Text(
                      "Impossible de charger les détails de l'événement",
                    ),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: _getTabs(state.eventDetails!),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getTabs(
    EventDetails eventDetails,
  ) {
    return [
      EventDetailsInfos(
        eventDetails: eventDetails,
        onViewOnMap: () {
          _tabController.animateTo(3);
        },
      ),
      EventDetailsImages(
        scrollController: _scrollController,
        eventId: eventDetails.event.id,
        isParticipating: eventDetails.isParticipating,
        onAddPhotos: _onAddPhotoFromAllPhotos,
      ),
      EventDetailsMyImages(
        scrollController: _scrollController,
        isParticipating: eventDetails.isParticipating,
        isImagesPublic:
            eventDetails.callerParticipation?.isImagesPublic ?? false,
        eventId: eventDetails.event.id,
      ),
      BlocProvider(
        create: (context) => UserPositionsBloc(),
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

  Widget? _getFloatingButton() {
    switch (currentTab) {
      case EventDetailsTab.info:
        return BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsLoadFailure ||
                state is EventDetailsLoadInProgress ||
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

  void _onAddPhotoFromAllPhotos() {
    _tabController.animateTo(2);

    Future.delayed(const Duration(milliseconds: 500), () {
      showEventImagesPicker(context, widget.event.id);
    });
  }

  Widget? _renderActions(EventDetailsState state) {
    final event = state.eventDetails;

    if (state is EventDetailsLoadInProgress ||
        state is EventDetailsLoadFailure ||
        event == null ||
        (!event.isOwner && !event.isParticipating && !event.isOrganizer)) {
      return null;
    }

    return TopBarActionContainer(
      child: EventDetailsActionsMenu(
        eventId: event.event.id,
        status: event.event.status,
        isOwner: event.isOwner,
        isJoined: event.isParticipating,
        isOrganizer: event.isOrganizer,
      ),
    );
  }

  void _loadEventDetails() {
    context.read<EventDetailsBloc>().add(
      LoadEventDetails(
        eventId: widget.event.id,
      ),
    );
  }

  void _onEdit(EventFormData formData) {
    context.read<EventDetailsBloc>().add(
      EditEvent(
        eventId: widget.event.id,
        formData: formData,
      ),
    );

    Navigator.of(context).pop();
  }
}
