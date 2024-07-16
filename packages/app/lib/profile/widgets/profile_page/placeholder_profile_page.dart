/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_banner/placeholder_profile_banner.dart';
import 'package:hollybike/profile/widgets/profile_description/placeholder_profile_description.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/tabs_loading_placeholder.dart';

class PlaceholderProfilePage extends StatefulWidget {
  final int? loadingProfileId;

  const PlaceholderProfilePage({
    super.key,
    this.loadingProfileId,
  });

  @override
  State<PlaceholderProfilePage> createState() => _PlaceholderProfilePageState();
}

class _PlaceholderProfilePageState extends State<PlaceholderProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlaceholderProfileBanner(loadingProfileId: widget.loadingProfileId),
        PlaceholderProfileDescription(
            loadingProfileId: widget.loadingProfileId),
        const SizedBox.square(dimension: 16),
        const TabsLoadingPlaceholder(length: 2),
      ],
    );
  }
}
