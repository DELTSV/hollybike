import 'package:flutter/material.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_titles/profile_title_container.dart';

class ProfileTitle extends StatelessWidget {
  final Profile profile;

  const ProfileTitle({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ProfileTitleContainer(children: [
      Text(
        "${profile.username} - ${profile.association.name}",
        style: Theme.of(context).textTheme.titleSmall,
        overflow: TextOverflow.ellipsis,
      ),
      Text(
        profile.email,
        style: Theme.of(context).textTheme.bodySmall,
        overflow: TextOverflow.ellipsis,
      ),
    ]);
  }
}
