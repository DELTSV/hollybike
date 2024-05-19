import 'package:flutter/material.dart';

class EventDate extends StatelessWidget {
  const EventDate({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Stack(
        children: [
          Material(
            clipBehavior: Clip.antiAlias,
            shape: BeveledRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                width: 2,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(9.0),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  width: 2,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "12",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
