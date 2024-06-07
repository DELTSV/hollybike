import 'package:flutter/material.dart';

import '../event_image.dart';

class EventDetailsHeader extends StatelessWidget {
  final int eventId;
  final EventImage eventImage;
  final String eventName;
  final bool animate;

  const EventDetailsHeader({
    super.key,
    required this.eventId,
    required this.eventImage,
    required this.eventName,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        children: [
          HeroMode(
            enabled: animate,
            child: Hero(
              tag: "event-image-$eventId",
              child: Container(
                width: double.infinity,
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: eventImage,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeroMode(
                      enabled: animate,
                      child: Hero(
                        tag: "event-name-$eventId",
                        child: SizedBox(
                          width: constraints.maxWidth - 20,
                          child: Text(
                            eventName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
