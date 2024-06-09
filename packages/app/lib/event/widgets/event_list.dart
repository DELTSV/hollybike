import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/utils/dates.dart';
import '../../shared/widgets/pinned_header_delegate.dart';
import '../bloc/events_bloc/events_bloc.dart';
import '../bloc/events_bloc/events_state.dart';
import '../types/minimal_event.dart';
import 'event_preview_card.dart';

class EventSection {
  String title;
  List<MinimalEvent> events;

  EventSection({required this.title, required this.events});
}

class EventList extends StatefulWidget {
  final List<MinimalEvent> events;
  final void Function(BuildContext context) onNextPageRequested;
  final void Function(BuildContext context) onRefreshRequested;
  final void Function(MinimalEvent event) onEventTap;
  final bool hasMore;

  const EventList({
    super.key,
    required this.events,
    required this.onNextPageRequested,
    required this.onEventTap,
    required this.onRefreshRequested,
    required this.hasMore,
  });

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final sections = getEventSections(widget.events);
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        widget.onRefreshRequested(context);
      },
      child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                for (var section in sections)
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: PinnedHeaderDelegate(
                            height: 50,
                            animationDuration: 300,
                            child: Container(
                              width: double.infinity,
                              color:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  section.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final event = section.events[index];

                              return TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                builder: (context, double value, child) {
                                  return Transform.translate(
                                    offset: Offset(30 * (1 - value), 0),
                                    child: Opacity(
                                      opacity: value,
                                      child: EventPreviewCard(
                                        event: event,
                                        onTap: () => widget.onEventTap(event),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: section.events.length,
                          ),
                        ),
                        if (widget.hasMore && section == sections.last)
                          const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
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
        widget.onNextPageRequested(context);
      }
    });
  }

  List<EventSection> getEventSections(List<MinimalEvent> events) {
    final sections = <EventSection>[];
    List<List<MinimalEvent>> groupedEvents = [];

    for (var i = 0; i < events.length; i++) {
      final event = events[i];

      if (i == 0 || event.startDate.month != events[i - 1].startDate.month) {
        groupedEvents.add([]);
      }

      groupedEvents.last.add(event);
    }

    for (var i = 0; i < groupedEvents.length; i++) {
      final events = groupedEvents[i];
      final title = getMonthWithDistantYear(events.first.startDate);

      sections.add(EventSection(title: title, events: events));
    }

    return sections;
  }
}
