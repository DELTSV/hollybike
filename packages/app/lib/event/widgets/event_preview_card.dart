import 'package:flutter/material.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/event_status.dart';

import 'event_form/event_date.dart';

class EventPreviewCard extends StatelessWidget {
  final MinimalEvent event;
  final void Function() onTap;

  const EventPreviewCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 110,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 110,
                      child: Hero(
                        tag: "event-image-${event.id}",
                        child: Stack(
                          children: [
                            SizedBox(
                              height: double.infinity,
                              child: Container(
                                foregroundDecoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Theme.of(context)
                                          .cardColor
                                          .withOpacity(0.5),
                                      Theme.of(context).cardColor,
                                    ],
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(10),
                                  ),
                                  child: Image(
                                    image: event.imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: EventDate(date: event.startDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Hero(
                                    tag: "event-name-${event.id}",
                                    child: SizedBox(
                                      width: constraints.maxWidth,
                                      child: Text(
                                        event.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              EventStatusIndicator(event: event),
                            ],
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
