import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../shared/widgets/bar/top_bar.dart';
import '../../shared/widgets/hud/hud.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_page/profile_page.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  final String? id;

  const ProfileScreen({super.key, @PathParam('id') this.id});

  @override
  Widget build(BuildContext context) {
    return Hud(
      displayNavBar: true,
      appBar: TopBar(
        prefix: TopBarActionIcon(
          icon: Icons.arrow_back,
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) => ProfilePage(
          profile:
              id == null ? null : bloc.getProfileById(int.parse(id as String)),
        ),
      ),
    );
  }
}
