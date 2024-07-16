/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner_background.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner_decoration.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class ProfileBanner extends StatelessWidget {
  final MinimalUser profile;
  final bool canEdit;

  const ProfileBanner({
    super.key,
    required this.profile,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ProfileBannerBackground(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ProfileBannerDecoration(
              profilePicture: ProfilePicture(
                user: profile,
                size: 100,
              ),
            ),
            if (canEdit)
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _onEditProfile(context),
                    child: const Text('Modifier'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
          ],
        ),
      ],
    );
  }

  void _onEditProfile(BuildContext context) {
    context.router.push(
      const EditProfileRoute(),
    );
  }
}
