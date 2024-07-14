
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_modal.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

class EventUploadImageModal extends StatefulWidget {
  const EventUploadImageModal({super.key});

  @override
  State<EventUploadImageModal> createState() => _EventUploadImageModalState();
}

class _EventUploadImageModalState extends State<EventUploadImageModal> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailsBloc, EventDetailsState>(
      listener: (context, state) {
        if (state is EventOperationSuccess) {
          Navigator.of(context).pop();
        }

        if (state is EventOperationInProgress) {
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
      child: ImagePickerModal(
        isLoading: _loading,
        mode: ImagePickerMode.single,
        onClose: () {
          Navigator.of(context).pop();
        },
        onSubmit: (images) => onSubmit(context, images),
      ),
    );
  }

  void onSubmit(BuildContext context, List<File> images) {
    final file = images.first;

    context.read<EventDetailsBloc>().add(
      UploadEventImage(
        imageFile: file,
      ),
    );
  }
}