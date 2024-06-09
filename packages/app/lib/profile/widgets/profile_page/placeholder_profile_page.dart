import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_banner/placeholder_profile_banner.dart';
import 'package:hollybike/profile/widgets/profile_description/placeholder_profile_description.dart';

class PlaceholderProfilePage extends StatelessWidget {
  const PlaceholderProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PlaceholderProfileBanner(),
        PlaceholderProfileDescription(),
      ],
    );
  }
}
