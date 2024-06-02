import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/dates.dart';

import 'event_date_clipper.dart';


class EventDate extends StatelessWidget {
  final DateTime date;

  const EventDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        children: [
          ClipPath(
            clipper: EventDateClipper(cornerRadius: 8, cornerRadius2: 15),
            child: Container(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              child: Center(
                child: Text(
                  "12",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipPath(
              clipper: EventDateClipper(cornerRadius: 5, cornerRadius2: 12),
              child: Container(
                color: Theme.of(context).cardColor,
                height: 40,
                width: 40,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getMinimalDay(date),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 10,
                            ),
                      ),
                      Text(
                        date.day.toString(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
