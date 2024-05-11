import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_gradient.dart';
import 'package:hollybike/shared/widgets/profile_picture/profile_picture_container.dart';

class LoadingProfilePicture extends StatelessWidget {
  final double size;

  const LoadingProfilePicture({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return ProfilePictureContainer(
      size: size,
      child: const LoadingGradient(),
    );
  }
}
