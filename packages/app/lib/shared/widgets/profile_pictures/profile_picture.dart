import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture_container.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class ProfilePicture extends StatelessWidget {
  final MinimalUser profile;
  final double size;

  const ProfilePicture({
    super.key,
    required this.profile,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final profilePicture = switch (profile.profilePicture) {
      String src => CachedNetworkImage(imageUrl: src),
      _ => Image.asset("assets/images/placeholder_profile_picture.jpg"),
    };

    return Hero(
      tag: "user-${profile.id}-profile-picture",
      child: ProfilePictureContainer(size: size, child: profilePicture),
    );
  }
}
