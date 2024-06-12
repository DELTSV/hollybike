import 'dart:io';

import 'package:flutter/material.dart';

import '../../widgets/image_picker/image_picker_modal.dart';

enum ImagePickerMode {
  single,
  multiple,
}

Future<void> showImagePicker(
  BuildContext context, {
  required Function(List<File>) onSubmit,
  ImagePickerMode mode = ImagePickerMode.single,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return ImagePickerModal(
        mode: mode,
        onClose: () {
          Navigator.of(context).pop();
        },
        onSubmit: onSubmit,
      );
    },
  );
}
