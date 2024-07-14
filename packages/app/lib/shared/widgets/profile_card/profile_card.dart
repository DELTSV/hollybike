import 'package:flutter/material.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_card/profile_card_container.dart';
import 'package:hollybike/shared/widgets/profile_titles/profile_title.dart';

import '../../../event/widgets/event_loading_profile_picture.dart';

class ProfileCard extends StatelessWidget {
  final AuthSession session;
  final Profile profile;
  final bool isCurrentUser;
  final Widget? endChild;

  final void Function(
    BuildContext context,
    AuthSession session,
    Profile profile,
  )? onTap;

  const ProfileCard({
    super.key,
    required this.session,
    required this.profile,
    this.isCurrentUser = false,
    this.onTap,
    this.endChild,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCardContainer(
      onTap: onTap == null ? null : () => _handleCardTap(context),
      profilePicture: UserProfilePicture(
        url: profile.profilePicture,
        profilePictureKey: profile.profilePictureKey,
        radius: 20,
      ),
      profileTitle: ProfileTitle(profile: profile),
      endChild: endChild,
    );
  }

  void _handleCardTap(BuildContext context) {
    onTap!(context, session, profile);
  }
}
