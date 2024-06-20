import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/fragments/future_events.dart';
import 'package:hollybike/event/fragments/user_events.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../app/app_router.gr.dart';
import '../../shared/types/tab_description.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/bar/top_bar_tab_dropdown.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../bloc/events_bloc/events_state.dart';
import '../bloc/events_bloc/future_events_bloc.dart';
import '../fragments/archived_events.dart';
import '../types/minimal_event.dart';
import '../widgets/add_event_floating_button.dart';

enum EventListTab { future, user, archived }

@RoutePage()
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  int _currentTab = EventListTab.future.index;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FutureEventsBloc, EventsState>(
          listener: (context, state) {
            if (state is EventCreationSuccess) {
              Toast.showSuccessToast(context, "Événement créé");

              Future.delayed(const Duration(milliseconds: 50), () {
                _navigateToEventDetails(
                  context,
                  state.createdEvent.toMinimalEvent(),
                  false,
                );
              });
            }

            if (state is EventCreationFailure) {
              Toast.showErrorToast(context, state.errorMessage);
            }
          },
        ),
        BlocListener<EventDetailsBloc, EventDetailsState>(
          listener: (context, state) {
            if (state is DeleteEventSuccess) {
              Toast.showSuccessToast(context, "Événement supprimé");
            }
          },
        ),
      ],
      child: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) {
          final tabs = [
            TabDescription(
              title: "Évènements",
              icon: Icons.event,
              fragment: FutureEvents(
                navigateToEventDetails: _onNavigateToEventDetails,
              ),
            ),
            TabDescription(
              title: "Vos évènements",
              icon: Icons.event_available,
              fragment: UserEvents(
                userId: bloc.currentProfile?.id,
                navigateToEventDetails: _onNavigateToEventDetails,
              ),
            ),
            TabDescription(
              title: "Archives",
              icon: Icons.archive_outlined,
              fragment: ArchivedEvents(
                navigateToEventDetails: _onNavigateToEventDetails,
              ),
            ),
          ];

          return Hud(
            appBar: TopBar(
              noPadding: true,
              title: TopBarTabDropdown(
                controller: _controller,
                entries: tabs
                    .map((tab) =>
                        TabDropdownEntry(title: tab.title, icon: tab.icon))
                    .toList(),
              ),
            ),
            floatingActionButton: _getFloatingActionButton(),
            body: TabBarView(
              controller: _controller,
              children: tabs.map((tab) => tab.fragment).toList(),
            ),
            displayNavBar: true,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

    _controller.animation?.removeListener(_updateTitle);
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: 3,
      vsync: this,
    );

    _currentTab = _controller.index;
    _controller.animation?.addListener(_updateTitle);
  }

  Widget? _getFloatingActionButton() {
    if (_currentTab == EventListTab.archived.index) {
      return null;
    }

    return const AddEventFloatingButton();
  }

  void _updateTitle() {
    final newTab = _controller.animation!.value.round();

    if (_currentTab != newTab) {
      setState(() {
        _currentTab = newTab;
      });
    }
  }

  void _onNavigateToEventDetails(MinimalEvent event) {
    _navigateToEventDetails(context, event, true);
  }

  void _navigateToEventDetails(
    BuildContext context,
    MinimalEvent event,
    bool animate,
  ) {
    Future.delayed(const Duration(milliseconds: 200), () {
      context.router.push(EventDetailsRoute(
        event: event,
        animate: animate,
      ));
    });
  }
}
