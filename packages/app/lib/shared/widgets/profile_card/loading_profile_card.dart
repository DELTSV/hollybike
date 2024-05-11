import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/profile_card/profile_card_container.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';
import 'package:hollybike/shared/widgets/profile_titles/loading_profile_title.dart';

class LoadingProfileCard extends StatelessWidget {
  final bool clickable;

  const LoadingProfileCard({
    super.key,
    this.clickable = false,
  });

  @override
  Widget build(BuildContext context) {
    return const ProfileCardContainer(
      clickable: true,
      profilePicture: LoadingProfilePicture(),
      profileTitle: LoadingProfileTitle(),
    );
  }
}
