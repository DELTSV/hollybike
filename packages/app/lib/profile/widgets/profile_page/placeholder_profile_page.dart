import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_banner/placeholder_profile_banner.dart';
import 'package:hollybike/profile/widgets/profile_description/placeholder_profile_description.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/gradient_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/tabs_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';

class PlaceholderProfilePage extends StatefulWidget {
  const PlaceholderProfilePage({
    super.key,
  });

  @override
  State<PlaceholderProfilePage> createState() => _PlaceholderProfilePageState();
}

class _PlaceholderProfilePageState extends State<PlaceholderProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PlaceholderProfileBanner(),
        PlaceholderProfileDescription(),
        SizedBox.square(dimension: 16),
        TabsLoadingPlaceholder(length: 2),
      ],
    );
  }
}
