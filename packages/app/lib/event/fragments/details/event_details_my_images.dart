import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../bloc/event_images_bloc/event_images_bloc.dart';
import '../../bloc/event_images_bloc/event_images_state.dart';

class EventDetailsMyImages extends StatelessWidget {
  const EventDetailsMyImages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventImagesBloc, EventImagesState>(
      listener: (context, state) {
        if (state is EventImagesUploadFailure) {
          Toast.showErrorToast(
            context,
            state.errorMessage,
          );
        }

        if (state is EventImagesUploadSuccess) {
          Toast.showSuccessToast(
            context,
            "Photos ajoutées avec succès",
          );
          Navigator.of(context).pop();
        }
      },
      child: const Center(
        child: Text("My images"),
      ),
    );
  }
}
