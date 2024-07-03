import 'package:flutter/material.dart';
import 'package:hollybike/event/types/minimal_event.dart';

class EventDetailsHeader extends StatelessWidget {
  final MinimalEvent event;
  final bool animate;
  final String uniqueKey;

  const EventDetailsHeader({
    super.key,
    required this.animate,
    required this.event,
    required this.uniqueKey,
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
              tag: "event-image-$uniqueKey",
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
                child: Image(
                  image: event.imageProvider,
                  fit: BoxFit.cover,
                ),
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
                        tag: "event-name-$uniqueKey",
                        child: SizedBox(
                          width: constraints.maxWidth - 20,
                          child: Text(
                            event.name,
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
