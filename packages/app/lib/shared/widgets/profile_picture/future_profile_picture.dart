import 'package:flutter/material.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_picture/loading_profile_picture.dart';
import 'package:hollybike/shared/widgets/profile_picture/profile_picture.dart';

class FutureProfilePicture extends StatelessWidget {
  final Future<Profile> profile;
  final double size;

  const FutureProfilePicture({
    super.key,
    required this.profile,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: profile,
      builder: _handleAsynchronousRendering,
    );
  }

  Widget _handleAsynchronousRendering(
    BuildContext context,
    AsyncSnapshot<Profile> snapshot,
  ) {
    return switch (snapshot) {
      AsyncSnapshot<Profile>(data: final profile) when profile != null =>
        ProfilePicture(
          profile: profile,
          size: size,
        ),
      _ => LoadingProfilePicture(size: size),
    };
  }
}
