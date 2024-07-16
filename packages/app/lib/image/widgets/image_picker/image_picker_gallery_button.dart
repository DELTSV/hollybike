/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_button_container.dart';

class ImagePickerGalleryButton extends StatelessWidget {
  final ImagePicker imagePicker = ImagePicker();
  final ImagePickerMode mode;
  final void Function(List<Img>) onImagesSelected;

  ImagePickerGalleryButton({
    super.key,
    required this.mode,
    required this.onImagesSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ImagePickerButtonContainer(
      onTap: _onGalleryTap,
      icon: const Icon(Icons.photo),
    );
  }

  _onGalleryTap() async {
    final images = await _pickImages();
    final imgs = images.map((image) => Img.fromFile(File(image.path))).toList();

    onImagesSelected(imgs);
  }

  Future<List<XFile>> _pickImages() async {
    if (mode == ImagePickerMode.single) {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      return image == null ? [] : [image];
    } else {
      return imagePicker.pickMultiImage();
    }
  }
}
