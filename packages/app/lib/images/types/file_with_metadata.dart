import 'dart:io';

import 'package:hollybike/images/types/image_metadata.dart';

class ImageWithMetadata {
  final File file;
  final ImageMetadata metadata;

  ImageWithMetadata({
    required this.file,
    required this.metadata,
  });
}