import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_bloc.dart';
import 'package:hollybike/shared/utils/image_picker/show_image_picker.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../bloc/event_images_bloc/event_images_event.dart';

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
        showImagePicker(
          context,
          mode: ImagePickerMode.multiple,
          onSubmit: (images) {
            withCurrentSession(
              context,
              (session) {
                context.read<EventImagesBloc>().add(
                      UploadEventImages(
                        session: session,
                        eventId: eventId,
                        images: images,
                      ),
                    );
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
