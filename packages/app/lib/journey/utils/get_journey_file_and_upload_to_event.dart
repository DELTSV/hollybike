import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../event/bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../event/bloc/event_journey_bloc/event_journey_event.dart';
import '../../event/types/event.dart';
import '../../event/widgets/journey/upload_journey_modal.dart';

Future<File?> getJourneyFileAndUploadToEvent(
    BuildContext context, Event event) async {
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

  File file = File(result.files.single.path!);

  BlocProvider.of<EventJourneyBloc>(context).add(
    UploadJourneyFileToEvent(
      eventId: event.id,
      name: event.name,
      file: file,
    ),
  );

  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return UploadJourneyModal(
        isGpx: extension == 'gpx',
      );
    },
  );

  return file;
}
