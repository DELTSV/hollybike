import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_state.dart';
import 'package:hollybike/images/types/image_metadata.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../../images/types/file_with_metadata.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../bloc/event_images_bloc/event_images_event.dart';
import 'add_photos_modal.dart';

class AddPhotosFloatingButton extends StatelessWidget {
  final int eventId;

  const AddPhotosFloatingButton({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return AddPhotosModal(
              onClose: () {
                Navigator.of(context).pop();
              },
              onSubmit: (images) {
                withCurrentSession(context, (session) {
                  context.read<EventImagesBloc>().add(
                        UploadEventImages(
                          session: session,
                          eventId: eventId,
                          images: images,
                        ),
                      );
                });
              },
            );
          },
        );
      },
      label: const Text("Ajouter des photos"),
      icon: const Icon(Icons.add_a_photo),
    );
  }
}
