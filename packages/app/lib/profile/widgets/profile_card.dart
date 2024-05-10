import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/profile/types/profile.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints.tight(const Size.square(40)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge,
            child: _getProfilePictureImage(),
          ),
          const SizedBox(width: 16),
          _getProfileName(context),
        ],
      ),
    );
  }

  Image _getProfilePictureImage() {
    return profile.profilePicture == null
        ? Image.asset("images/placeholder_profile_picture.jpg")
        : Image.network(profile.profilePicture as String);
  }

  Widget _getProfileName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.username,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          profile.email,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
