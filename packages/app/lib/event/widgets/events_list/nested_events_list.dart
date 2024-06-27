import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_preview_card/event_preview_card.dart';

import '../../../shared/utils/dates.dart';
import '../../../shared/widgets/pinned_header_delegate.dart';
import '../../types/minimal_event.dart';
import 'events_sections_list.dart';

class NestedEventsList extends StatelessWidget {
  final List<MinimalEvent> events;
  final void Function(MinimalEvent) onEventTap;

  const NestedEventsList({
    super.key,
    required this.events,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: CustomScrollView(
        slivers: getEventSections(events)
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
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        section.events
                            .map(
                              (event) => EventPreviewCard(
                                event: event,
                                onTap: () => onEventTap(event),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
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
