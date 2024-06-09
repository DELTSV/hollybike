import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_page/profile_page.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../shared/widgets/bar/top_bar.dart';
import '../../shared/widgets/bar/top_bar_title.dart';
import '../../shared/widgets/hud/hud.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_modal/profile_modal.dart';

@RoutePage()
class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

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
      body: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) => ProfilePage(profile: bloc.currentProfile),
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
