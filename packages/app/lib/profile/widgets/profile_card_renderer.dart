import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/bloc/profile_repository.dart';
import 'package:hollybike/profile/widgets/profile_card.dart';
import 'package:hollybike/profile/widgets/profile_loading_card.dart';

import '../types/profile.dart';

class ProfileCardRenderer extends StatelessWidget {
  final AuthSession session;

  const ProfileCardRenderer({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final profile = RepositoryProvider.of<ProfileRepository>(context)
        .getSessionProfile(session);

    return FutureBuilder(
      future: profile,
      builder: _handleAsynchronousRendering,
    );
  }

  Widget _handleAsynchronousRendering(
      BuildContext context, AsyncSnapshot<Profile> snapshot) {
    return switch (snapshot) {
      AsyncSnapshot<Profile>(data: final profile) when profile != null =>
        ProfileCard(
          session: session,
          profile: profile,
        ),
      _ => const ProfileLoadingCard(),
    };
  }
}
