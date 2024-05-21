import 'package:flutter/material.dart';

import 'event_form.dart';

class EventCreationModal extends StatelessWidget {
  const EventCreationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: Theme.of(context).colorScheme.onPrimary,
      width: 3,
    );

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          top: border,
          left: border,
          right: border,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          // vertical: 16,
        ),
        child: Column(
          children: [
            Text(
              'Créer un événement',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Expanded(
              // height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: EventForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
