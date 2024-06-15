import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/fragments/future_events.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../shared/types/tab_description.dart';
import '../../shared/widgets/bar/top_bar_tab_dropdown.dart';
import '../fragments/archived_events.dart';
import '../widgets/add_event_floating_button.dart';

@RoutePage()
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late final List<TabDescription> _tabs;
  late final TabController _controller;

  @override
  Widget build(BuildContext context) {
    return Hud(
      appBar: TopBar(
        noPadding: true,
        title: TopBarTabDropdown(
          controller: _controller,
          entries: _tabs
              .map((tab) => TabDropdownEntry(title: tab.title, icon: tab.icon))
              .toList(),
        ),
      ),
      floatingActionButton: const AddEventFloatingButton(),
      body: TabBarView(
        controller: _controller,
        children: _tabs.map((tab) => tab.fragment).toList(),
      ),
      displayNavBar: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabs = [
      const TabDescription(
        title: "Évènements",
        icon: Icons.event,
        fragment: FutureEvents(),
      ),
      const TabDescription(
        title: "Archives",
        icon: Icons.archive_outlined,
        fragment: ArchivedEvents(),
      ),
    ];

    _controller = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
