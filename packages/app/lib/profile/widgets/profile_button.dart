import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/hud/widgets/hud_button.dart';
import 'package:hollybike/profile/bloc/profile_repository.dart';
import 'package:hollybike/profile/widgets/profile_modal.dart';
import 'package:hollybike/shared/widgets/profile_pictures/future_profile_picture.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/profile_picture_loading_placeholder.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return HudButton(
          onLongPress: () => _handleLongPress(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderProfilePicture(context, state.currentSession),
            ],
          ),
        );
      },
    );
  }

  void _handleLongPress(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileModal(),
    );
  }

  Widget _renderProfilePicture(BuildContext context, AuthSession? session) {
    if (session == null) {
      return const ProfilePictureLoadingPlaceholder();
    }

    final profile = RepositoryProvider.of<ProfileRepository>(context)
        .getSessionProfile(session);
    return FutureProfilePicture(profile: profile);
  }
}
