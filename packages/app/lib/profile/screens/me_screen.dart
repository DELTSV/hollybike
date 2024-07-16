/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_page/profile_page.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../shared/widgets/bar/top_bar.dart';
import '../../shared/widgets/hud/hud.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../widgets/profile_modal/profile_modal.dart';

@RoutePage()
class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Hud(
      displayNavBar: true,
      appBar: TopBar(
        suffix: TopBarActionIcon(
          colorInverted: true,
          icon: Icons.settings,
          onPressed: () => _handlePrefixClick(context),
        ),
        title: const TopBarTitle("Mon profil"),
      ),
      body: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) {
          final currentProfile = bloc.currentProfile;

          if (currentProfile is ProfileLoadingEvent) {
            return const ProfilePage(
              profileLoading: true,
              profile: null,
              association: null,
            );
          }

          if (currentProfile is ProfileLoadSuccessEvent) {
            return ProfilePage(
              profileLoading: false,
              email: currentProfile.profile.email,
              profile: currentProfile.profile.toMinimalUser(),
              association: currentProfile.profile.association,
              isMe: true,
            );
          }

          return const ProfilePage(
            profileLoading: false,
            profile: null,
            association: null,
          );
        },
      ),
    );
  }

  void _handlePrefixClick(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileModal(),
    );
  }
}
