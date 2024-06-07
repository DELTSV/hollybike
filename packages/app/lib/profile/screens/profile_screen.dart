import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';

import '../../shared/widgets/bar/top_bar.dart';
import '../../shared/widgets/bar/top_bar_title.dart';
import '../../shared/widgets/hud/hud.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Hud(
      displayNavBar: true,
      appBar: const TopBar(
        title: TopBarTitle('Mon profil'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Center(
            child: Text(state.currentProfile?.username ?? 'No profile'),
          );
        },
      ),
    );
  }
}
