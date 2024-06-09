import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner.dart';
import 'package:hollybike/profile/widgets/profile_description/profile_description.dart';
import 'package:hollybike/profile/widgets/profile_page/placeholder_profile_page.dart';

import '../../types/profile.dart';

class ProfilePage extends StatelessWidget {
  final Profile? profile;

  const ProfilePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const PlaceholderProfilePage();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileBanner(profile: profile as Profile),
          ProfileDescription(profile: profile as Profile),
        ],
      ),
    );
  }
}
