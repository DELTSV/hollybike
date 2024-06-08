import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner.dart';
import 'package:hollybike/profile/widgets/profile_description/placeholder_profile_description.dart';
import 'package:hollybike/profile/widgets/profile_description/profile_description.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';

import '../../shared/widgets/bar/top_bar.dart';
import '../../shared/widgets/bar/top_bar_title.dart';
import '../../shared/widgets/hud/hud.dart';
import '../widgets/profile_banner/placeholder_profile_banner.dart';
import '../widgets/profile_modal/profile_modal.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Hud(
      displayNavBar: true,
      appBar: TopBar(
        prefix: TopBarActionIcon(
          icon: Icons.swap_horiz,
          onPressed: () => _handlePrefixClick(context),
        ),
        title: const TopBarTitle('Mon profil'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final profile = state.currentProfile;

          if (profile == null) {
            return const Column(
              children: [
                PlaceholderProfileBanner(),
                PlaceholderProfileDescription(),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileBanner(profile: profile),
                ProfileDescription(profile: profile),
              ],
            ),
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
