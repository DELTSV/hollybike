/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../event/types/event.dart';

Future<PlatformFile?> getJourneyFile(
  BuildContext context,
  Event event,
) async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any,
  );

  if (result == null) {
    return null;
  }

  final extension = result.files.single.extension;

  if (!context.mounted) return null;

  if (extension != 'gpx' && extension != 'geojson') {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fichier invalide"),
          content: const Text(
            "Le fichier doit être au format GPX ou GEOJSON",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );

    return null;
  }

  return result.files.single;
}
