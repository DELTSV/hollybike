import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

import '../../../image/bloc/image_list_state.dart';
import '../../../image/type/image_picker_mode.dart';
import '../../../image/widgets/image_picker/image_picker_modal.dart';
import '../../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../../bloc/event_images_bloc/event_my_images_event.dart';

class EventImagePickerModal extends StatefulWidget {
  const EventImagePickerModal({super.key});

  @override
  State<EventImagePickerModal> createState() => _EventImagePickerModalState();
}

class _EventImagePickerModalState extends State<EventImagePickerModal> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventMyImagesBloc, ImageListState>(
      listener: (context, state) {
        if (state is ImageListOperationSuccess) {
          Navigator.of(context).pop();
        }

        if (state is ImageListOperationInProgress) {
          setState(() {
            _loading = true;
          });
        } else {
          Future.delayed(const Duration(milliseconds: 300), () {
            safeSetState(() {
              _loading = false;
            });
          });
        }
      },
      child: BlocBuilder<EventMyImagesBloc, ImageListState>(
        builder: (context, state) {
          return ImagePickerModal(
            isLoading: _loading,
            mode: ImagePickerMode.multiple,
            onClose: () {
              Navigator.of(context).pop();
            },
            onSubmit: (images) => onSubmit(context, images),
          );
        },
      ),
    );
  }

  void onSubmit(BuildContext context, List<File> images) {
    context.read<EventMyImagesBloc>().add(
      UploadEventImages(
        images: images,
      ),
    );
  }
}
