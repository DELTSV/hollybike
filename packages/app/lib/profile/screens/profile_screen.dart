import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../shared/widgets/bar/top_bar.dart';
import '../../shared/widgets/hud/hud.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../widgets/profile_page/profile_page.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  final String? urlId;

  const ProfileScreen({super.key, @PathParam('id') this.urlId});

  @override
  Widget build(BuildContext context) {
    return Hud(
      appBar: TopBar(
        prefix: TopBarActionIcon(
          icon: Icons.arrow_back,
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) {
          try {
            return buildProfilePage(context, bloc, state);
          } catch (_) {
            return const ProfilePage(
              profile: null,
              association: null,
            );
          }
        },
      ),
    );
  }

  Widget buildProfilePage(
    BuildContext context,
    ProfileBloc bloc,
    ProfileState state,
  ) {
    final id = urlId == null ? int.parse(urlId as String) : null;
    if (id == null) throw Error();

    final currentProfile = bloc.currentProfile;
    final user = bloc.getUserById(id);
    if (user is! UserLoadSuccessEvent ||
        currentProfile is! ProfileLoadSuccessEvent) throw Error();

    return ProfilePage(
      id: id,
      profile: user.user,
      association: currentProfile.profile.association,
    );
  }
}
