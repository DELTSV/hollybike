import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_gallery_button.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_thumbnail.dart';
import 'package:hollybike/shared/utils/permissions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

import 'image_picker_camera_button.dart';

class ImagePickerChoiceList extends StatefulWidget {
  final List<String> mediumIdSelectedList;
  final ImagePickerMode mode;
  final void Function(List<Img>) onImagesSelected;
  final bool isLoading;

  const ImagePickerChoiceList({
    super.key,
    required this.mediumIdSelectedList,
    required this.mode,
    required this.onImagesSelected,
    required this.isLoading,
  });

  @override
  State<ImagePickerChoiceList> createState() => _ImagePickerChoiceListState();
}

class _ImagePickerChoiceListState extends State<ImagePickerChoiceList> {
  final mediumIdList = <String>[];
  bool _loadingImages = true;
  final imagePicker = ImagePicker();

  get isLoading => _loadingImages || widget.isLoading;

  @override
  void initState() {
    super.initState();

    _checkImagesPermission().then(
      (granted) {
        if (granted) {
          return _loadImages();
        }
      },
    ).whenComplete(() {
      setState(() {
        _loadingImages = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      ImagePickerCameraButton(
        onImageSelected: (image) => widget.onImagesSelected([image]),
      ),
      ...mediumIdList.map((mediumId) {
        return ImagePickerThumbnail(
          mediumId: mediumId,
          isSelected: widget.mediumIdSelectedList.contains(mediumId),
          onImageSelected: (image) => widget.onImagesSelected([image]),
        );
      }),
      ImagePickerGalleryButton(
        mode: widget.mode,
        onImagesSelected: widget.onImagesSelected,
      )
    ];

    const height = 100.0;

    return AnimatedCrossFade(
      crossFadeState:
          isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
      firstChild: SizedBox(
        height: height,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      secondChild: SizedBox(
        height: height,
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
    });
  }

  Future<bool> _checkImagesPermission() async {
    await Permission.accessMediaLocation.requestAndCheck();

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt <= 32) {
        return Permission.storage.requestAndCheck();
      }
    }

    return Permission.photos.requestAndCheck();
  }
}
