import 'package:flutter/material.dart';

import '../../../shared/utils/dates.dart';
import '../../../shared/widgets/pinned_header_delegate.dart';
import '../../types/minimal_event.dart';
import '../event_preview_card.dart';

class EventSection {
  String title;
  List<MinimalEvent> events;

  EventSection({required this.title, required this.events});
}

class EventsSectionsList extends StatelessWidget {
  final List<MinimalEvent> events;
  final void Function(MinimalEvent) onEventTap;
  final bool hasMore;
  final ScrollController? controller;

  const EventsSectionsList({
    super.key,
    required this.events,
    required this.onEventTap,
    required this.hasMore,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final sections = getEventSections(events);

    return CustomScrollView(
      controller: controller,
      slivers: sections
          .map(
            (section) => SliverMainAxisGroup(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PinnedHeaderDelegate(
                    height: 50,
                    animationDuration: 300,
                    child: Container(
                      width: double.infinity,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: Text(
                          section.title,
                          style: Theme.of(context).textTheme.titleMedium,
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
                                onTap: () => onEventTap(event),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: section.events.length,
                  ),
                ),
                if (hasMore && section == sections.last)
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
          )
          .toList(),
    );
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
