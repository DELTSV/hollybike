import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_event.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_state.dart';

import '../../../shared/types/paginated_list.dart';
import '../../services/image/image_repository.dart';
import '../../types/image/event_image.dart';

class EventImagesBloc extends Bloc<EventImagesEvent, EventImagesState> {
  final int numberOfImagesPerRequest = 20;

  final ImageRepository imageRepository;

  EventImagesBloc({
    required this.imageRepository,
  }) : super(EventImagesInitial()) {
    on<LoadEventImagesNextPage>(_onLoadEventImagesNextPage);
    on<RefreshEventImages>(_onRefreshEventImages);
  }

  Future<void> _onLoadEventImagesNextPage(
    LoadEventImagesNextPage event,
    Emitter<EventImagesState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventImagesStatus.loading) {
      return;
    }

    emit(EventImagesPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.fetchEventImages(
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

  Future<void> _onRefreshEventImages(
    RefreshEventImages event,
    Emitter<EventImagesState> emit,
  ) async {
    emit(EventImagesPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.refreshEventImages(
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
}
