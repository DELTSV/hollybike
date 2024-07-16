/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_modal.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ProfilePictureImagePickerModal extends StatefulWidget {
  final void Function(File) onImageSelected;

  const ProfilePictureImagePickerModal({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<ProfilePictureImagePickerModal> createState() =>
      _EventImagePickerModalState();
}

class _EventImagePickerModalState
    extends State<ProfilePictureImagePickerModal> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ImagePickerModal(
      isLoading: _loading,
      mode: ImagePickerMode.single,
      onClose: () {
        Navigator.of(context).pop();
      },
      onSubmit: (images) => onSubmit(context, images),
    );
  }

  void onSubmit(BuildContext context, List<File> images) async {
    safeSetState(() {
      _loading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () async {
      final image = images.first;

      try {
        final imageBytes = await applyRoundedCorners(image.path);

        final tempFile = writeTempFile(imageBytes);

        widget.onImageSelected(tempFile);

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          Toast.showErrorToast(context, 'Image incompatible. Veuillez réessayer.');
        }
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        safeSetState(() {
          _loading = false;
        });
      });
    });
  }

  File writeTempFile(List<int> bytes) {
    final tempDir = Directory.systemTemp;
    final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();

    final filePath = path.join(
      tempDir.path,
      'hollybike_temp_profile_picture_$uniqueKey.png',
    );
    final file = File(filePath);
    file.writeAsBytesSync(bytes);

    return file;
  }

  Future<Uint8List> applyRoundedCorners(String imagePath) async {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception("Failed to decode image");
    }

    final alphaImage = img.copyCropCircle(
      image.convert(numChannels: 4),
    );

    final resizedImage = img.copyResize(
      alphaImage,
      width: 256,
      height: 256,
    );

    return img.encodePng(resizedImage);
  }
}
