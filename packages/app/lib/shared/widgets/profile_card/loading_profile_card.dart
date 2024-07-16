/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/profile_card/profile_card_container.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';
import 'package:hollybike/shared/widgets/profile_titles/loading_profile_title.dart';

class LoadingProfileCard extends StatelessWidget {
  final bool clickable;
  final Widget? endChild;

  const LoadingProfileCard({super.key, this.clickable = false, this.endChild});

  @override
  Widget build(BuildContext context) {
    return ProfileCardContainer(
      clickable: true,
      profilePicture: const LoadingProfilePicture(),
      profileTitle: const LoadingProfileTitle(),
      endChild: endChild,
    );
  }
}
