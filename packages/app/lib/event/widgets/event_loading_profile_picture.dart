import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/loading_placeholders/gradient_loading_placeholder.dart';

class UserProfilePicture extends StatelessWidget {
  final String? url;
  final double radius;
  final bool isLoading;

  const UserProfilePicture({
    super.key,
    this.url,
    required this.radius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final loadingPlaceHolder = CircleAvatar(
      radius: radius,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(300.0),
        child: const GradientLoadingPlaceholder(),
      ),
    );

    if (isLoading) {
      return loadingPlaceHolder;
    }

    final placeHolder = CircleAvatar(
      radius: radius,
      backgroundImage: Image.asset(
        "assets/images/placeholder_profile_picture.jpg",
      ).image,
    );

    if (url == null || url!.isEmpty) {
      return placeHolder;
    }

    return CachedNetworkImage(
      imageUrl: url!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => loadingPlaceHolder,
      errorWidget: (context, url, error) => placeHolder,
    );
  }
}
