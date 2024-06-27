import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/gradient_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture_container.dart';

class LoadingProfilePicture extends StatelessWidget {
  final int? loadingProfileId;
  final double size;

  const LoadingProfilePicture({
    super.key,
    this.size = 40,
    this.loadingProfileId,
  });

  @override
  Widget build(BuildContext context) {
    final profilePicture = ProfilePictureContainer(
      size: size,
      child: const GradientLoadingPlaceholder(),
    );

    if (loadingProfileId == null) return profilePicture;
    return Hero(
      tag: loadingProfileId == null
          ? ""
          : "user-$loadingProfileId-profile-picture",
      child: profilePicture,
    );
  }
}
