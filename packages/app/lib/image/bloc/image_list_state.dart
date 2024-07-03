
import 'package:flutter/cupertino.dart';

import '../type/event_image.dart';

enum EventImagesStatus { loading, success, error, initial }

@immutable
class ImageListState {
  final List<EventImage> images;

  final bool hasMore;
  final int nextPage;

  final EventImagesStatus status;

  const ImageListState({
    this.images = const [],
    this.hasMore = true,
    this.nextPage = 0,
    this.status = EventImagesStatus.initial,
  });

  ImageListState.state(ImageListState state)
      : this(
    images: state.images,
    hasMore: state.hasMore,
    nextPage: state.nextPage,
    status: state.status,
  );

  ImageListState copyWith({
    EventImagesStatus? status,
    List<EventImage>? images,
    bool? hasMore,
    int? nextPage,
  }) {
    return ImageListState(
      status: status ?? this.status,
      images: images ?? this.images,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class ImageListInitial extends ImageListState {}

class ImageListPageLoadInProgress extends ImageListState {
  ImageListPageLoadInProgress(ImageListState state)
      : super.state(state.copyWith(status: EventImagesStatus.loading));
}

class ImageListPageLoadSuccess extends ImageListState {
  ImageListPageLoadSuccess(ImageListState state)
      : super.state(state.copyWith(status: EventImagesStatus.success));
}

class ImageListPageLoadFailure extends ImageListState {
  final String errorMessage;

  ImageListPageLoadFailure(ImageListState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventImagesStatus.error));
}

class ImageListOperationInProgress extends ImageListState {
  ImageListOperationInProgress(ImageListState state)
      : super.state(state.copyWith(status: EventImagesStatus.loading));
}

class ImageListOperationSuccess extends ImageListState {
  final bool shouldRefresh;
  final String? successMessage;

  ImageListOperationSuccess(ImageListState state,
      {this.shouldRefresh = false, this.successMessage})
      : super.state(state.copyWith(status: EventImagesStatus.success));
}

class ImageListOperationFailure extends ImageListState {
  final String errorMessage;

  ImageListOperationFailure(ImageListState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventImagesStatus.error));
}
