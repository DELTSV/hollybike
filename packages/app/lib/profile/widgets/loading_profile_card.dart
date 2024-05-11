import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/profile_picture_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/profile_title_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';

class LoadingProfileCard extends StatelessWidget {
  const LoadingProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfilePictureLoadingPlaceholder(),
          SizedBox(width: 16),
          ProfileTitleLoadingPlaceholder(),
        ],
      ),
    );
  }
}
