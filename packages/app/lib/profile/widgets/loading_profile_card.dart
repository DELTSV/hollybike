import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/profile_picture_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';

class LoadingProfileCard extends StatelessWidget {
  const LoadingProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ProfilePictureLoadingPlaceholder(),
          const SizedBox(width: 16),
          _getProfileName(context),
        ],
      ),
    );
  }

  Widget _getProfileName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLoadingPlaceholder(
          textStyle: Theme.of(context).textTheme.titleSmall,
          minLetters: 4,
          maxLetters: 12,
        ),
        const SizedBox(height: 4),
        TextLoadingPlaceholder(
          textStyle: Theme.of(context).textTheme.bodySmall,
          minLetters: 13,
          maxLetters: 25,
        ),
      ],
    );
  }
}
