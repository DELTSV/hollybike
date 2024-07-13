import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture_container.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class ProfilePicture extends StatelessWidget {
  final MinimalUser profile;
  final double size;
  final bool editMode;
  final void Function()? onTap;
  final File? file;

  const ProfilePicture({
    super.key,
    required this.profile,
    this.size = 40,
    this.editMode = false,
    this.onTap,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    final profilePicture = _buildImage();

    if (editMode) {
      return Stack(
        children: [
          HeroMode(
            enabled: !editMode,
            child: Hero(
              tag: "user-${profile.id}-profile-picture",
              child: ProfilePictureContainer(size: size, child: profilePicture),
            ),
          ),
          ProfilePictureContainer(
            size: size,
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          ProfilePictureContainer(
            size: size,
            child: Center(
              child: Icon(
                Icons.add_a_photo_outlined,
                color: const Color(0xffcdd6f4),
                size: size / 3,
              ),
            )
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(size / 2),
                onTap: onTap,
              ),
            ),
          ),
        ],
      );
    }

    return Hero(
      tag: "user-${profile.id}-profile-picture",
      child: ProfilePictureContainer(size: size, child: profilePicture),
    );
  }

  Widget _buildImage() {
    if (file != null) {
      return Image.file(file!);
    }

    if (profile.profilePicture == null) {
      return Image.asset("assets/images/placeholder_profile_picture.jpg");
    }

    return Image.network(profile.profilePicture!);
  }
}
