import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

import '../../utils/image_picker/img.dart';
import 'image_picker_thumbnail_container.dart';

class ImagePickerThumbnail extends StatelessWidget {
  final String mediumId;
  final bool isSelected;
  final void Function(Img) onImageSelected;

  const ImagePickerThumbnail({
    super.key,
    required this.mediumId,
    required this.isSelected,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ImagePickerThumbnailContainer(
      isSelected: isSelected,
      child: Image(
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
      ),
      onTap: () async => onImageSelected(await Img.fromMediumId(mediumId)),
    );
  }
}
