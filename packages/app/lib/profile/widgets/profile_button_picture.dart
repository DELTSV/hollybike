import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';

import '../../shared/widgets/profile_pictures/future_profile_picture.dart';
import '../bloc/profile_repository.dart';

class ProfileButtonPicture extends StatelessWidget {
  const ProfileButtonPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      final AuthState(currentSession: session) = state;

      if (session == null) {
        return const LoadingProfilePicture();
      }

      final profile = RepositoryProvider.of<ProfileRepository>(context)
          .getSessionProfile(session);
      return FutureProfilePicture(profile: profile);
    });
  }
}
