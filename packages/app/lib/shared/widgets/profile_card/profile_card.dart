import 'package:flutter/material.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_card/profile_card_container.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';
import 'package:hollybike/shared/widgets/profile_titles/profile_title.dart';

class ProfileCard extends StatelessWidget {
  final AuthSession session;
  final Profile profile;
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
    this.onTap,
    this.endChild,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCardContainer(
      onTap: onTap == null ? null : () => _handleCardTap(context),
      profilePicture: ProfilePicture(profile: profile),
      profileTitle: ProfileTitle(profile: profile),
      endChild: endChild,
    );
  }

  void _handleCardTap(BuildContext context) {
    onTap!(context, session, profile);
  }
}
