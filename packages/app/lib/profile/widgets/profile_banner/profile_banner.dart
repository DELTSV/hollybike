import 'package:flutter/material.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner_background.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner_decoration.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';

class ProfileBanner extends StatelessWidget {
  final Profile profile;

  const ProfileBanner({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ProfileBannerBackground(),
        ProfileBannerDecoration(
          profilePicture: ProfilePicture(
            profile: profile,
            size: 100,
          ),
        ),
      ],
    );
  }
}
