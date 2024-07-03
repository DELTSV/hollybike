import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:hollybike/shared/utils/permissions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'image_picker_button_container.dart';

class ImagePickerCameraButton extends StatelessWidget {
  final ImagePicker imagePicker = ImagePicker();
  final void Function(Img) onImageSelected;

  ImagePickerCameraButton({
    super.key,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ImagePickerButtonContainer(
      onTap: _onCameraTap,
      icon: const Icon(Icons.camera_alt),
    );
  }

  _onCameraTap() async {
    final cameraPermission = await Permission.camera.requestAndCheck();

    if (!cameraPermission) {
      return;
    }

    final image = await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final img = Img.fromFile(File(image.path));

      onImageSelected(img);
    }
  }
}
