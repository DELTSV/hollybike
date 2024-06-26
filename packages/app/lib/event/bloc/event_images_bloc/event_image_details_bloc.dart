import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../../services/image/image_repository.dart';
import 'event_image_details_event.dart';
import 'event_image_details_state.dart';

class EventImageDetailsBloc
    extends Bloc<EventImageDetailsEvent, EventImageDetailsState> {
  final ImageRepository imageRepository;

  EventImageDetailsBloc({
    required this.imageRepository,
  }) : super(EventImageDetailsInitial()) {
    on<GetEventImageDetails>(_onGetEventImageDetails);
    on<DeleteImage>(_onDeleteImage);
  }

  Future<void> _onGetEventImageDetails(
    GetEventImageDetails event,
    Emitter<EventImageDetailsState> emit,
  ) async {
    emit(EventImageDetailsLoadInProgress(state));

    try {
      final imageDetails = await imageRepository.getImageDetails(
        event.imageId,
      );

      emit(EventImageDetailsLoadSuccess(
        state.copyWith(imageDetails: imageDetails),
      ));
    } catch (e) {
      log('Error while loading image details: $e');
      emit(EventImageDetailsLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue',
      ));
      return;
    }
  }

  Future<void> _onDeleteImage(
    DeleteImage event,
    Emitter<EventImageDetailsState> emit,
  ) async {
    emit(DeleteImageInProgress(state));

    try {
      await imageRepository.deleteImage(
        event.imageId,
      );

      emit(DeleteImageSuccess(state));
    } catch (e) {
      log('Error while deleting image: $e');
      emit(EventImageDetailsLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue',
      ));
      return;
    }
  }
}
