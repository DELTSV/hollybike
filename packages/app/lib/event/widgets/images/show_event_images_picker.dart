import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/utils/image_picker/show_image_picker.dart';

import '../../../image/widgets/image_picker/image_picker_modal.dart';
import '../../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../../bloc/event_images_bloc/event_my_images_event.dart';

void showEventImagesPicker(BuildContext context, int eventId) {
  void onSubmit(BuildContext context, List<File> images) {
    context.read<EventMyImagesBloc>().add(
          UploadEventImages(
            images: images,
          ),
        );
  }

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return BlocListener<EventMyImagesBloc, ImageListState>(
        listener: (context, state) {
          if (state is ImageListOperationSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<EventMyImagesBloc, ImageListState>(
          builder: (context, state) {
            return ImagePickerModal(
              isLoading: state is ImageListOperationInProgress,
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
