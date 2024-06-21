import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';

class PlaceholderProfileDescription extends StatelessWidget {
  final int? loadingProfileId;

  const PlaceholderProfileDescription({super.key, this.loadingProfileId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: addSeparators(
          [
            _renderUsernamePlaceholder(
              TextLoadingPlaceholder(
                textStyle: Theme.of(context).textTheme.titleMedium,
                minLetters: 3,
                maxLetters: 10,
              ),
            ),
            const TextLoadingPlaceholder(
              minLetters: 12,
              maxLetters: 18,
            ),
            const TextLoadingPlaceholder(
              minLetters: 12,
              maxLetters: 18,
            ),
          ],
          const SizedBox.square(dimension: 8),
        ),
      ),
    );
  }

  Widget _renderUsernamePlaceholder(Widget placeholder) =>
      loadingProfileId == null
          ? placeholder
          : Hero(
              tag: "user-$loadingProfileId-username",
              child: placeholder,
            );
}
