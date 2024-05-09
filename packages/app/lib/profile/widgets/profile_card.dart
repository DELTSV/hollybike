import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/bloc/profile_repository.dart';

import '../types/profile.dart';

class ProfileCard extends StatelessWidget {
  final AuthSession session;

  const ProfileCard({
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

  Widget _handleAsynchronousRendering(BuildContext context, AsyncSnapshot<Profile> snapshot) {
    return switch(snapshot) {
      AsyncSnapshot<Profile>(hasData: final hasData) when hasData => const Text("load"),
      AsyncSnapshot<Profile>(hasError: final hasError) when hasError => const Text("error"),
      _ => const Text("loading"),
    };
  }
}
