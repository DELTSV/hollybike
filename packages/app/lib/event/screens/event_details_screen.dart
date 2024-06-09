import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/widgets/details/event_details_content.dart';
import 'package:hollybike/event/widgets/details/event_details_header.dart';
import 'package:hollybike/event/widgets/details/event_edit_floating_button.dart';
import 'package:hollybike/event/widgets/event_image.dart';
import 'package:hollybike/event/widgets/images/add_photos_floating_button.dart';
import 'package:hollybike/map/widgets/map_preview.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_container.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/pinned_header_delegate.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_event.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../widgets/details/event_details_actions_menu.dart';

enum EventDetailsTab { info, photos, myPhotos, map }

@RoutePage()
class EventDetailsScreen extends StatefulWidget {
  final int eventId;
  final EventImage eventImage;
  final String eventName;
  final bool animate;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.eventImage,
    required this.eventName,
    this.animate = true,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> with SingleTickerProviderStateMixin {
  var eventName = "";
  late TabController _tabController;
  EventDetailsTab currentTab = EventDetailsTab.info;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }

      setState(() {
        currentTab = EventDetailsTab.values[_tabController.index];
      });
    });

    setState(() {
      eventName = widget.eventName;
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
          eventName = state.eventDetails?.event.name ?? widget.eventName;
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
          child: CustomScrollView(
            slivers: [
              SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: EventDetailsHeader(
                      eventId: widget.eventId,
                      eventName: eventName,
                      eventImage: widget.eventImage,
                      animate: widget.animate,
                    ),
                  ),
                ],
              ),
              SliverMainAxisGroup(
                slivers: [
                  SliverPersistentHeader(
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
                  SliverToBoxAdapter(
                    child: BlocBuilder<EventDetailsBloc, EventDetailsState>(
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

                        return SizedBox(
                          height: 500,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              EventDetailsContent(
                                eventDetails: state.eventDetails!,
                              ),
                              const Center(
                                child: Text("Images"),
                              ),
                              const Center(
                                child: Text("My images"),
                              ),
                              const MapPreview(),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
        return const AddPhotosFloatingButton();
      case EventDetailsTab.map:
        return null;
    }
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
        isOwner: event.isOwner,
        isJoined: event.isParticipating,
        isOrganizer: event.isOrganizer,
      ),
    );
  }

  void _loadEventDetails() {
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

  void _onEdit(EventFormData formData) {
    withCurrentSession(context, (session) {
      context.read<EventDetailsBloc>().add(
            EditEvent(
              session: session,
              eventId: widget.eventId,
              formData: formData,
            ),
          );
    });

    Navigator.of(context).pop();
  }
}
