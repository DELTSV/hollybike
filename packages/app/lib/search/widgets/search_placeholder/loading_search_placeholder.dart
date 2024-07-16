/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_preview_card/placeholder_event_preview_card.dart';
import 'package:hollybike/search/widgets/search_profile_card/placeholder_search_profile_card.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';

import '../../../shared/utils/add_separators.dart';

class LoadingSearchPlaceholder extends StatelessWidget {
  const LoadingSearchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return OverflowBar(
      children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: TextLoadingPlaceholder(
                minLetters: 20,
                maxLetters: 21,
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: addSeparators(
                  [
                    const SizedBox.square(dimension: 4),
                    const PlaceholderSearchProfileCard(),
                    const PlaceholderSearchProfileCard(),
                    const PlaceholderSearchProfileCard(),
                    const PlaceholderSearchProfileCard(),
                    const SizedBox.square(dimension: 4),
                  ],
                  const SizedBox.square(dimension: 8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: TextLoadingPlaceholder(
                minLetters: 20,
                maxLetters: 21,
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ] +
          addSeparators(
            [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: PlaceholderEventPreviewCard(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: PlaceholderEventPreviewCard(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: PlaceholderEventPreviewCard(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: PlaceholderEventPreviewCard(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: PlaceholderEventPreviewCard(),
              ),
            ],
            const SizedBox.square(dimension: 4),
          ),
    );
  }
}
