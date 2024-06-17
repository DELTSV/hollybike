import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../shared/widgets/loading_placeholders/gradient_loading_placeholder.dart';

class JourneyImage extends StatelessWidget {
  final int journeyId;
  final bool loadingData;
  final String? imageUrl;

  const JourneyImage({
    super.key,
    required this.journeyId,
    this.loadingData = false,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      if (loadingData) {
        return const GradientLoadingPlaceholder();
      }

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
