import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_my_images_bloc.dart';
import 'package:hollybike/shared/utils/image_picker/show_image_picker.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../bloc/event_images_bloc/event_my_images_event.dart';

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
                context.read<EventMyImagesBloc>().add(
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
      label: Text(
        "Ajouter des photos",
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      icon: const Icon(Icons.add_a_photo),
    );
  }
}
