import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_my_images_bloc.dart';
import 'package:hollybike/event/widgets/images/event_image_picker_modal.dart';

void showEventImagesPicker(BuildContext context, int eventId) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<EventMyImagesBloc>(),
        child: const EventImagePickerModal(),
      );
    },
  );
}
