import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/profile.dart';

class ProfileCard extends StatelessWidget {
  final AuthSession session;
  final Profile profile;

  const ProfileCard({
    super.key,
    required this.session,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleCardTap(context),
      child: Container(
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
      ),
    );
  }

  void _handleCardTap(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthSessionSwitch(newSession: session));
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
