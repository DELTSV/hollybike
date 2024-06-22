import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner_background.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner_decoration.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';

class PlaceholderProfileBanner extends StatelessWidget {
  final int? loadingProfileId;

  const PlaceholderProfileBanner({
    super.key,
    this.loadingProfileId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ProfileBannerBackground(),
        ProfileBannerDecoration(
          profilePicture: LoadingProfilePicture(
            size: 100,
            loadingProfileId: loadingProfileId,
          ),
        ),
      ],
    );
  }
}
