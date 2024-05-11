import 'package:flutter/material.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_picture/profile_picture_container.dart';

class ProfilePicture extends StatelessWidget {
  final Profile profile;
  final double size;

  const ProfilePicture({
    super.key,
    required this.profile,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final profilePicture = switch (profile.profilePicture) {
      String src => Image.network(src),
      _ => Image.asset("images/placeholder_profile_picture.jpg"),
    };

    return ProfilePictureContainer(size: size, child: profilePicture);
  }
}
