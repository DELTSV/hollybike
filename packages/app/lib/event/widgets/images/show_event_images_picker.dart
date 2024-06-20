import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/event_images_bloc/event_images_state.dart';
import '../../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../../bloc/event_images_bloc/event_my_images_event.dart';
import '../../../shared/utils/image_picker/show_image_picker.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../../shared/widgets/image_picker/image_picker_modal.dart';

void showEventImagesPicker(BuildContext context, int eventId) {
  void onSubmit(BuildContext context, List<File> images) {
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
        child: BlocBuilder<EventMyImagesBloc, EventImagesState>(
          builder: (context, state) {
            return ImagePickerModal(
              isLoading: state is EventImagesOperationInProgress,
              mode: ImagePickerMode.multiple,
              onClose: () {
                Navigator.of(context).pop();
              },
              onSubmit: (images) => onSubmit(context, images),
            );
          },
        ),
      );
    },
  );
}