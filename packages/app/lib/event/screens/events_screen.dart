import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/fragments/future_events.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

@RoutePage()
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Hud(
      appBar: TopBar(title: TopBarTitle("Événements à Venir")),
      body: FutureEvents(),
      displayNavBar: true,
    );
  }
}
