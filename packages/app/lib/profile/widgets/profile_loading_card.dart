import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_profile_picture.dart';
import 'package:hollybike/shared/widgets/loading_text.dart';

class ProfileLoadingCard extends StatelessWidget {
  const ProfileLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const LoadingProfilePicture(),
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
        LoadingText(
          textStyle: Theme.of(context).textTheme.titleSmall,
          minLetters: 4,
          maxLetters: 12,
        ),
        const SizedBox(height: 4),
        LoadingText(
          textStyle: Theme.of(context).textTheme.bodySmall,
          minLetters: 13,
          maxLetters: 25,
        ),
      ],
    );
  }
}
