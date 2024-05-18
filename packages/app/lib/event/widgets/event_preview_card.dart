import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';

class EventPreviewCard extends StatelessWidget {
  final Event event;

  const EventPreviewCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 130,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(10),
                        ),
                        child: event.image == null
                            ? Image.asset(
                                "images/placeholder_event_image.jpg",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                event.image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(event.name),
                          Text(event.startDate.toString()),
                        ],
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
                  onTap: () => {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
