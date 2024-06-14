import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_state.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_my_images_bloc.dart';
import 'package:hollybike/shared/utils/image_picker/show_image_picker.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../../../shared/widgets/image_picker/image_picker_modal.dart';
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
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return BlocListener<EventMyImagesBloc, EventImagesState>(
              listener: (context, state) {
                if (state is EventImagesOperationSuccess) {
                  Navigator.of(context).pop();
                }
              },
              child: ImagePickerModal(
                mode: ImagePickerMode.multiple,
                onClose: () {
                  Navigator.of(context).pop();
                },
                onSubmit: (images) {
                  _onSubmit(context, images);
                },
              ),
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

  void _onSubmit(BuildContext context, List<File> images) {
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
  }
}
