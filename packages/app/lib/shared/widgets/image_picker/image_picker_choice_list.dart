import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/image_picker/img.dart';
import 'package:hollybike/shared/utils/image_picker/show_image_picker.dart';
import 'package:hollybike/shared/widgets/image_picker/image_picker_gallery_button.dart';
import 'package:hollybike/shared/widgets/image_picker/image_picker_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

import 'image_picker_camera_button.dart';
class ImagePickerChoiceList extends StatefulWidget {
  final List<String> mediumIdSelectedList;
  final ImagePickerMode mode;
  final void Function(List<Img>) onImagesSelected;

  const ImagePickerChoiceList({
    super.key,
    required this.mediumIdSelectedList,
    required this.mode,
    required this.onImagesSelected,
  });

  @override
  State<ImagePickerChoiceList> createState() =>
      _ImagePickerChoiceListState();
}

class _ImagePickerChoiceListState extends State<ImagePickerChoiceList> {
  final mediumIdList = <String>[];
  bool _loadingImages = true;
  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkImagesPermission();
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      ...mediumIdList.map((mediumId) {
        return ImagePickerThumbnail(
          mediumId: mediumId,
          isSelected: widget.mediumIdSelectedList.contains(mediumId),
          onImageSelected: (image) => widget.onImagesSelected([image]),
        );
      }),
      ImagePickerCameraButton(
        onImageSelected: (image) => widget.onImagesSelected([image]),
      ),
      ImagePickerGalleryButton(
        mode: widget.mode,
        onImagesSelected: widget.onImagesSelected,
      )
    ];

    return AnimatedCrossFade(
      crossFadeState:
          _loadingImages ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
      firstChild: const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      secondChild: SizedBox(
        height: 100,
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 8);
          },
          padding: const EdgeInsets.symmetric(horizontal: 8),
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return AspectRatio(
              aspectRatio: 1,
              child: list[index],
            );
          },
        ),
      ),
    );
  }

  Future<bool> _checkPositionPermission() async {
    final status = await Permission.accessMediaLocation.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      return openAppSettings().then((value) => value);
    }

    return false;
  }

  void _loadImages() {
    PhotoGallery.listAlbums(
      mediumType: MediumType.image,
      newest: true,
      hideIfEmpty: true,
    ).then((albums) async {
      final album = albums.firstOrNull;

      if (album != null) {
        final mediaPage = await album.listMedia(
          take: 10,
        );

        setState(() {
          mediumIdList.addAll(mediaPage.items.map((e) => e.id));
        });
      }
    }).whenComplete(
      () => setState(() {
        _loadingImages = false;
      }),
    );
  }

  _checkImagesPermission() async {
    await _checkPositionPermission();
    final status = await Permission.photos.request();
    if (status.isGranted) {
      _loadImages();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
