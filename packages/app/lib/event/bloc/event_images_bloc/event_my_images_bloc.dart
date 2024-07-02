import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_state.dart';

import '../../../shared/types/paginated_list.dart';
import '../../services/event/event_repository.dart';
import '../../services/image/image_repository.dart';
import '../../types/image/event_image.dart';
import 'event_my_images_event.dart';

class EventMyImagesBloc extends Bloc<EventMyImagesEvent, EventImagesState> {
  final int numberOfImagesPerRequest = 20;

  final ImageRepository imageRepository;
  final EventRepository eventRepository;

  EventMyImagesBloc({
    required this.imageRepository,
    required this.eventRepository,
  }) : super(EventImagesInitial()) {
    on<LoadMyEventImagesNextPage>(_onLoadMyEventImagesNextPage);
    on<RefreshMyEventImages>(_onRefreshMyEventImages);
    on<UploadEventImages>(_onUploadEventImages);
    on<UpdateImagesVisibility>(_onUpdateImagesVisibility);
  }

  Future<void> _onLoadMyEventImagesNextPage(
    LoadMyEventImagesNextPage event,
    Emitter<EventImagesState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventImagesStatus.loading) {
      return;
    }

    emit(EventImagesPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.fetchMyEventImages(
        event.eventId,
        state.nextPage,
        numberOfImagesPerRequest,
      );

      emit(EventImagesPageLoadSuccess(state.copyWith(
        images: [...state.images, ...page.items],
        hasMore: page.items.length == numberOfImagesPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of images', error: e);
      emit(EventImagesPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRefreshMyEventImages(
    RefreshMyEventImages event,
    Emitter<EventImagesState> emit,
  ) async {
    emit(EventImagesPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page =
          await imageRepository.refreshMyEventImages(
        event.eventId,
        numberOfImagesPerRequest,
      );

      emit(EventImagesPageLoadSuccess(state.copyWith(
        images: page.items,
        hasMore: page.items.length == numberOfImagesPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing images', error: e);
      emit(EventImagesPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onUploadEventImages(
    UploadEventImages event,
    Emitter<EventImagesState> emit,
  ) async {
    emit(EventImagesOperationInProgress(state));

    try {
      await imageRepository.uploadEventImages(
        event.eventId,
        event.images,
      );

      emit(EventImagesOperationSuccess(
        state,
        shouldRefresh: true,
        successMessage: "Photos ajoutées avec succès",
      ));
    } catch (e) {
      log('Error while uploading images', error: e);
      emit(EventImagesOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onUpdateImagesVisibility(
    UpdateImagesVisibility event,
    Emitter<EventImagesState> emit,
  ) async {
    emit(EventImagesOperationInProgress(state));

    try {
      await imageRepository.updateImagesVisibility(
        event.eventId,
        event.isPublic,
      );

      eventRepository.onImagesVisibilityUpdated(event.isPublic, event.eventId);

      emit(EventImagesOperationSuccess(state));
    } catch (e) {
      log('Error while updating images visibility', error: e);
      emit(EventImagesOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}
