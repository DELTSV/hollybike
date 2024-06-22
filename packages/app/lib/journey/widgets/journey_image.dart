import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class JourneyImage extends StatelessWidget {
  final int journeyId;
  final String? imageUrl;

  const JourneyImage({
    super.key,
    required this.journeyId,
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
      imageUrl: imageUrl!,
      cacheKey: "preview-$journeyId",
      fit: BoxFit.cover,
    );
  }
}
