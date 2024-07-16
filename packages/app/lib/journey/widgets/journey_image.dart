/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class JourneyImage extends StatelessWidget {
  final String? imageKey;
  final String? imageUrl;

  const JourneyImage({
    super.key,
    this.imageKey,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return const Center(
        child: Icon(
          CupertinoIcons.map,
          size: 48,
        ),
      );
    }

    return CachedNetworkImage(
      cacheKey: imageKey,
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
    );
  }
}
