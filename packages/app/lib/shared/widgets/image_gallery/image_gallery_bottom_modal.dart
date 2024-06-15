import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_event.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_state.dart';
import 'package:hollybike/event/types/image/event_image_details.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/shared/widgets/image_gallery/image_details/image_gallery_details.dart';
import 'package:http/http.dart';

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import 'package:share_plus/share_plus.dart';
import '../../../event/types/image/event_image.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class ImageGalleryBottomModal extends StatefulWidget {
  final EventImage image;

  const ImageGalleryBottomModal({
    super.key,
    required this.image,
  });

  @override
  State<ImageGalleryBottomModal> createState() =>
      _ImageGalleryBottomModalState();
}

class _ImageGalleryBottomModalState extends State<ImageGalleryBottomModal> {
  @override
  void initState() {
    super.initState();

    withCurrentSession(context, (session) {
      BlocProvider.of<EventImageDetailsBloc>(context).add(
        GetEventImageDetails(
          session: session,
          imageId: widget.image.id,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
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
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                        label: const Text("Supprimer"),
                      ),
                    ],
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
    );
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
}
