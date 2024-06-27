import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:photo_gallery/photo_gallery.dart';

class Img {
  final Image image;
  final File file;
  final String? mediumId;

  Img({
    required this.image,
    required this.file,
    this.mediumId,
  });

  static Img fromFile(File file) {
    final image = Image(
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      image: FileImage(file),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }

        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );

    return Img(
      image: image,
      file: file,
    );
  }

  static Future<Img> fromMediumId(String mediumId) async {
    final file = await PhotoGallery.getMedium(mediumId: mediumId)
        .then((value) => value.getFile());
    final image = Image(
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      image: ThumbnailProvider(
        mediumId: mediumId,
        mediumType: MediumType.image,
        width: 512,
        height: 512,
        highQuality: true,
      ),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }

        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );

    return Img(
      image: image,
      file: file,
      mediumId: mediumId,
    );
  }
}
