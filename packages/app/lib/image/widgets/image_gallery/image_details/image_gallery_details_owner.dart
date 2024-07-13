import 'package:flutter/material.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../../../event/widgets/event_loading_profile_picture.dart';

class ImageGalleryDetailsOwner extends StatelessWidget {
  final MinimalUser owner;

  const ImageGalleryDetailsOwner({
    super.key,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserProfilePicture(
              url: owner.profilePicture,
              radius: 18,
            ),
            const SizedBox(width: 20),
            Text(
              owner.username,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
