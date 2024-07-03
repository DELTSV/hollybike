import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/image/bloc/image_list_bloc.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/services/image_repository.dart';

import '../../../image/type/event_image.dart';
import '../../../shared/types/paginated_list.dart';
import '../../services/event/event_repository.dart';
import 'event_my_images_event.dart';

class EventMyImagesBloc extends ImageListBloc<EventMyImagesEvent> {
  final int numberOfImagesPerRequest = 20;

  final int eventId;

  final ImageRepository imageRepository;
  final EventRepository eventRepository;

  EventMyImagesBloc({
    required this.eventId,
    required this.imageRepository,
    required this.eventRepository,
  }) : super(ImageListInitial()) {
    on<LoadMyEventImagesNextPage>(_onLoadMyEventImagesNextPage);
    on<RefreshMyEventImages>(_onRefreshMyEventImages);
    on<UploadEventImages>(_onUploadEventImages);
    on<UpdateImagesVisibility>(_onUpdateImagesVisibility);
  }

  Future<void> _onLoadMyEventImagesNextPage(
    LoadMyEventImagesNextPage event,
    Emitter<ImageListState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventImagesStatus.loading) {
      return;
    }

    emit(ImageListPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.fetchMyEventImages(
        eventId,
        state.nextPage,
        numberOfImagesPerRequest,
      );

      emit(ImageListPageLoadSuccess(state.copyWith(
        images: [...state.images, ...page.items],
        hasMore: page.items.length == numberOfImagesPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of images', error: e);
      emit(ImageListPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRefreshMyEventImages(
    RefreshMyEventImages event,
    Emitter<ImageListState> emit,
  ) async {
    emit(ImageListPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page =
          await imageRepository.refreshMyEventImages(
        eventId,
        numberOfImagesPerRequest,
      );

      emit(ImageListPageLoadSuccess(state.copyWith(
        images: page.items,
        hasMore: page.items.length == numberOfImagesPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing images', error: e);
      emit(ImageListPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onUploadEventImages(
    UploadEventImages event,
    Emitter<ImageListState> emit,
  ) async {
    emit(ImageListOperationInProgress(state));

    try {
      await imageRepository.uploadEventImages(
        eventId,
        event.images,
      );

      emit(ImageListOperationSuccess(
        state,
        shouldRefresh: true,
        successMessage: "Photos ajoutées avec succès",
      ));
    } catch (e) {
      log('Error while uploading images', error: e);
      emit(ImageListOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onUpdateImagesVisibility(
    UpdateImagesVisibility event,
    Emitter<ImageListState> emit,
  ) async {
    emit(ImageListOperationInProgress(state));

    try {
      await imageRepository.updateImagesVisibility(
        eventId,
        event.isPublic,
      );

      eventRepository.onImagesVisibilityUpdated(event.isPublic, eventId);

      emit(ImageListOperationSuccess(state));
    } catch (e) {
      log('Error while updating images visibility', error: e);
      emit(ImageListOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}

extension FirstWhenNotLoading on EventMyImagesBloc {
  Future<ImageListState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! ImageListPageLoadInProgress;
    });
  }
}
