/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/async_renderer.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';

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
    return AsyncRenderer(
      future: profile,
      builder: (profile) => ProfilePicture(
        user: profile.toMinimalUser(),
        size: size,
      ),
      placeholder: LoadingProfilePicture(size: size),
    );
  }
}
