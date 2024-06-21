import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';

import '../../../app/app_router.gr.dart';

class PlaceholderSearchProfileCard extends StatelessWidget {
  const PlaceholderSearchProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: 180,
      child: Material(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {},
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                LoadingProfilePicture(size: 50),
                SizedBox.square(dimension: 8),
                TextLoadingPlaceholder(minLetters: 3, maxLetters: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
