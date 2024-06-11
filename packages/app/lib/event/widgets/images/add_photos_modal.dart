import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/images/add_photo_button_container.dart';
import 'package:hollybike/event/widgets/images/add_photo_image_container.dart';
import 'package:hollybike/event/widgets/images/add_photo_selected_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
}

class AddPhotosModal extends StatefulWidget {
  final void Function() onClose;
  final void Function(List<File>) onSubmit;

  const AddPhotosModal({
    super.key,
    required this.onClose,
    required this.onSubmit,
  });

  @override
  State<AddPhotosModal> createState() => _AddPhotosModalState();
}

class _AddPhotosModalState extends State<AddPhotosModal> {
  final mediumIdList = <String>[];
  final imagePicker = ImagePicker();
  final _selectedImages = <Img>[];

  bool _loadingImages = true;

  @override
  void initState() {
    super.initState();

    _checkImagesPermission();
  }

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: Theme.of(context).colorScheme.onPrimary,
      width: 3,
    );

    final list = [
      ..._buildImages(),
      AddPhotoButtonContainer(
        onTap: _onCameraTap,
        icon: const Icon(Icons.camera_alt),
      ),
      AddPhotoButtonContainer(
        onTap: _onGalleryTap,
        icon: const Icon(Icons.photo),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          top: border,
          left: border,
          right: border,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
                  ElevatedButton(
                    onPressed: _selectedImages.isNotEmpty ? _onSubmit : null,
                    child: const Text("Ajouter"),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Builder(builder: (context) {
                if (_selectedImages.isEmpty) {
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
                        itemCount: _selectedImages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AspectRatio(
                            aspectRatio: 1,
                            child: AddPhotoSelectedImage(
                              child: _selectedImages[index].image,
                              onDelete: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
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
              }),
              AnimatedCrossFade(
                crossFadeState: _loadingImages
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final files = _selectedImages.map((img) => img.file).toList();
    widget.onSubmit(files);
  }

  List<Widget> _buildImages() {
    return mediumIdList.map((mediumId) {
      return AddPhotoImageContainer(
        isSelected:
            _selectedImages.any((element) => element.mediumId == mediumId),
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
        onTap: () {
          final selected =
              _selectedImages.any((element) => element.mediumId == mediumId);

          if (selected) {
            setState(() {
              _selectedImages
                  .removeWhere((element) => element.mediumId == mediumId);
            });
          } else {
            _onImageSelected(mediumId);
          }
        },
      );
    }).toList();
  }

  _onGalleryTap() async {
    final images = await imagePicker.pickMultiImage();

    final imgs =
        await Future.wait(images.map((image) => fileToImg(File(image.path))));

    setState(() {
      _selectedImages.addAll(imgs);
    });
  }

  Future<bool> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      return openAppSettings().then((value) => value);
    }

    return false;
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

  _onCameraTap() async {
    if (await _checkCameraPermission() == false) {
      return;
    }

    final image = await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final img = await fileToImg(File(image.path));

      setState(() {
        _selectedImages.add(img);
      });
    }
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

  void _onImageSelected(String mediumId) async {
    final img = await mediumIdToImg(mediumId);

    setState(() {
      _selectedImages.add(img);
    });
  }

  Widget _buildImageAnimation(
      Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    }

    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }

  Future<Img> fileToImg(File file) async {
    final image = Image(
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      image: FileImage(file),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return _buildImageAnimation(
          child,
          frame,
          wasSynchronouslyLoaded,
        );
      },
    );

    return Img(
      image: image,
      file: file,
    );
  }

  Future<Img> mediumIdToImg(String mediumId) async {
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
        return _buildImageAnimation(
          child,
          frame,
          wasSynchronouslyLoaded,
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
