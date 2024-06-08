import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_description/profile_description_spec.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';

import '../../types/profile.dart';

class PlaceholderProfileDescription extends StatelessWidget {
  const PlaceholderProfileDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: addSeparators(
          [
            TextLoadingPlaceholder(
              textStyle: Theme.of(context).textTheme.titleMedium,
              minLetters: 3,
              maxLetters: 10,
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
}
