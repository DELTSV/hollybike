import 'package:flutter/material.dart';

import '../../utils/image_picker/img.dart';
import 'image_picker_selected_image.dart';

class ImagePickerSelectedImagesList extends StatelessWidget {
  final List<Img> selectedImages;
  final void Function(int) onDeleteIndex;

  const ImagePickerSelectedImagesList({
    super.key,
    required this.selectedImages,
    required this.onDeleteIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 8);
            },
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: selectedImages.length,
            itemBuilder: (BuildContext context, int index) {
              return AspectRatio(
                aspectRatio: 1,
                child: ImagePickerSelectedImage(
                  child: selectedImages[index].image,
                  onDelete: () => onDeleteIndex(index),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
