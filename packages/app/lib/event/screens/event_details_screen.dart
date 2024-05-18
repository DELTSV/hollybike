import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_image.dart';

@RoutePage()
class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    @PathParam('eventId') required this.eventId,
    required this.eventImage,
  });

  final int eventId;
  final EventImage eventImage;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Hero(
              tag: widget.eventId,
              child: Container(
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
                child: widget.eventImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
