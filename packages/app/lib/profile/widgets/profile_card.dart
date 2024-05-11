import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';
import 'package:hollybike/shared/widgets/profile_titles/profile_title.dart';

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
            ProfilePicture(profile: profile),
            const SizedBox(width: 16),
            ProfileTitle(profile: profile),
          ],
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthSessionSwitch(newSession: session));
  }
}
