import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../event/types/image/event_image.dart';
import 'package:path/path.dart' as path;


class ImageGalleryBottomModal extends StatefulWidget {
  final EventImage image;

  const ImageGalleryBottomModal({
    super.key,
    required this.image,
  });

  @override
  State<ImageGalleryBottomModal> createState() => _ImageGalleryBottomModalState();
}

class _ImageGalleryBottomModalState extends State<ImageGalleryBottomModal> {
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
        child: SizedBox(
          height: 200,
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
                  // Row(
                  //   children: [
                  //     TextButton.icon(
                  //       onPressed: () {},
                  //       icon: const Icon(Icons.edit),
                  //       label: const Text("Modifier"),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  Future<String> _downloadImageToPath(String imagePath) async {
    var response = await get(Uri.parse(widget.image.url));
    var filePathAndName = path.join(imagePath, 'hollybike-${widget.image.id}.jpg');
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
        Toast.showErrorToast(context, "Erreur lors du téléchargement de l'image");
      }
    }
  }
}
