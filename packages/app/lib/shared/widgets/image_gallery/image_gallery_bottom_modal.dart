import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_event.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_state.dart';
import 'package:hollybike/event/types/image/event_image_details.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/shared/widgets/image_gallery/image_details/image_gallery_details.dart';
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../event/types/image/event_image.dart';

class ImageGalleryBottomModal extends StatefulWidget {
  final EventImage image;
  final void Function() onImageDeleted;

  const ImageGalleryBottomModal({
    super.key,
    required this.image,
    required this.onImageDeleted,
  });

  @override
  State<ImageGalleryBottomModal> createState() =>
      _ImageGalleryBottomModalState();
}

class _ImageGalleryBottomModalState extends State<ImageGalleryBottomModal> {
  bool _isImageOwner = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<EventImageDetailsBloc>(context).add(
      GetEventImageDetails(
        imageId: widget.image.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventImageDetailsBloc, EventImageDetailsState>(
      listener: (context, state) {
        if (state is DeleteImageSuccess) {
          widget.onImageDeleted();
        }

        if (state is EventImageDetailsLoadSuccess) {
          setState(() {
            _isImageOwner = state.imageDetails?.isOwner ?? false;
          });
        }

        if (state is EventImageDetailsLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(31),
              topRight: Radius.circular(31),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: _buildActions(),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  BlocBuilder<EventImageDetailsBloc, EventImageDetailsState>(
                    builder: (context, state) {
                      if (state is EventImageDetailsLoadInProgress) {
                        return const CircularProgressIndicator();
                      }

                      if (state.imageDetails == null) {
                        return const Text("Image non trouvée");
                      }

                      return ImageGalleryDetails(
                        imageDetails: state.imageDetails as EventImageDetails,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    final actions = <Widget>[
      TextButton.icon(
        onPressed: _onShareImage,
        icon: const Icon(Icons.share),
        label: const Text("Partager"),
      ),
      TextButton.icon(
        onPressed: _onDownloadImage,
        icon: const Icon(Icons.download),
        label: const Text("Télécharger"),
      ),
    ];

    if (_isImageOwner) {
      actions.add(
        TextButton.icon(
          onPressed: _onDeleteImage,
          icon: const Icon(Icons.delete),
          label: const Text("Supprimer"),
        ),
      );
    }

    return actions;
  }

  Future<String> _downloadImageToPath(String imagePath) async {
    var response = await get(Uri.parse(widget.image.url));
    var filePathAndName = path.join(
      imagePath,
      'hollybike-${widget.image.id}.jpg',
    );
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);

    return filePathAndName;
  }

  void _onShareImage() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final imagePath = await _downloadImageToPath(directory.path);

    Share.shareXFiles(
      [XFile(imagePath)],
      text: "Partage de l'image depuis Hollybike",
    );
  }

  void _onDownloadImage() async {
    try {
      await _downloadImageToPath("/storage/emulated/0/Download/");

      if (mounted) {
        Toast.showSuccessToast(context, "Image téléchargée avec succès");
      }
    } catch (e) {
      if (mounted) {
        Toast.showErrorToast(
            context, "Erreur lors du téléchargement de l'image");
      }
    }
  }

  void _onDeleteImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Suppression de l'image"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette image ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                context.read<EventImageDetailsBloc>().add(
                  DeleteImage(
                    imageId: widget.image.id,
                  ),
                );

                Navigator.of(context).pop();
              },
              child: const Text("Confirmer"),
            ),
          ],
        );
      },
    );
  }
}
