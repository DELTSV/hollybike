import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../shared/widgets/bar/top_bar.dart';
import '../../shared/widgets/hud/hud.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../widgets/profile_page/profile_page.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  final String? urlId;

  const ProfileScreen({super.key, @PathParam('id') this.urlId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _title = '';

  @override
  Widget build(BuildContext context) {
    return Hud(
      appBar: TopBar(
        prefix: TopBarActionIcon(
          icon: Icons.arrow_back,
          onPressed: () => context.router.maybePop(),
        ),
        title: TopBarTitle(_title),
      ),
      body: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) => buildProfilePage(
          context,
          bloc,
          state,
        ),
      ),
    );
  }

  Widget buildProfilePage(
    BuildContext context,
    ProfileBloc bloc,
    ProfileState state,
  ) {
    final id = widget.urlId == null ? null : int.parse(widget.urlId as String);
    if (id == null) return _buildError();

    final currentProfile = bloc.currentProfile;

    if (currentProfile is ProfileLoadingEvent) return _buildLoading();
    if (currentProfile is ProfileLoadErrorEvent) return _buildError();

    final user = bloc.getUserById(id);

    if (user is UserLoadingEvent) return _buildLoading();
    if (user is UserLoadErrorEvent) return _buildError();

    if (currentProfile is ProfileLoadSuccessEvent && user is UserLoadSuccessEvent) {
      bool isMe = currentProfile.profile.id == user.user.id;

      if (_title.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _title = isMe ? 'Mon profil' : 'Profil de ${user.user.username}';
          });
        });
      }

      return ProfilePage(
        id: id,
        profileLoading: false,
        isMe: isMe,
        email: isMe ? currentProfile.profile.email : null,
        profile: user.user,
        association: currentProfile.profile.association,
      );
    }

    return const SizedBox();
  }

  Widget _buildError() {
    return const ProfilePage(
      id: null,
      profileLoading: false,
      profile: null,
      association: null,
    );
  }

  Widget _buildLoading() {
    return const ProfilePage(
      id: null,
      profileLoading: true,
      profile: null,
      association: null,
    );
  }
}
