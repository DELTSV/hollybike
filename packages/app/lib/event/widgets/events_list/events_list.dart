/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/events_list/events_sections_list.dart';

import '../../types/minimal_event.dart';

class EventsList extends StatefulWidget {
  final List<MinimalEvent> events;
  final void Function() onNextPageRequested;
  final void Function() onRefreshRequested;
  final bool hasMore;

  const EventsList({
    super.key,
    required this.events,
    required this.onNextPageRequested,
    required this.onRefreshRequested,
    required this.hasMore,
  });

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  late final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: EventsSectionsList(
        events: widget.events,
        hasMore: widget.hasMore,
        controller: _scrollController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        widget.onNextPageRequested();
      }
    });
  }
}
