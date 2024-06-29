import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_preview_card/placeholder_event_preview_card.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';

class EventsListLoadingPlaceholder extends StatelessWidget {
  const EventsListLoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: renderSection() +
            renderSection() +
            renderSection(),
      ),
    );
  }

  List<Widget> renderSection() {
    final numberOfEvents = 2 + (Random()).nextInt(5 - 2);
    return const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: TextLoadingPlaceholder(minLetters: 5, maxLetters: 12),
          ),
        ] +
        List.generate(numberOfEvents, (_) => const PlaceholderEventPreviewCard());
  }
}
