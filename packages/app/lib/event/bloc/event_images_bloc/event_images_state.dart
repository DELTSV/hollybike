import 'package:flutter/foundation.dart';

import '../../types/image/event_image.dart';

enum EventImagesStatus { loading, success, error, initial }


@immutable
class EventImagesState {
  final List<EventImage> images;

  final bool hasMore;
  final int nextPage;

  final EventImagesStatus status;

  const EventImagesState({
    this.images = const [],
    this.hasMore = true,
    this.nextPage = 0,
    this.status = EventImagesStatus.initial,
  });

  EventImagesState.state(EventImagesState state)
      : this(
    images: state.images,
    hasMore: state.hasMore,
    nextPage: state.nextPage,
    status: state.status,
  );

  EventImagesState copyWith({
    EventImagesStatus? status,
    List<EventImage>? images,
    bool? hasMore,
    int? nextPage,
  }) {
    return EventImagesState(
      status: status ?? this.status,
      images: images ?? this.images,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class EventImagesInitial extends EventImagesState {}

class EventImagesPageLoadInProgress extends EventImagesState {
  EventImagesPageLoadInProgress(EventImagesState state)
      : super.state(state.copyWith(status: EventImagesStatus.loading));
}

class EventImagesPageLoadSuccess extends EventImagesState {
  EventImagesPageLoadSuccess(EventImagesState state)
      : super.state(state.copyWith(status: EventImagesStatus.success));
}

class EventImagesPageLoadFailure extends EventImagesState {
  final String errorMessage;

  EventImagesPageLoadFailure(EventImagesState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventImagesStatus.error));
}

class EventImagesOperationInProgress extends EventImagesState {
  EventImagesOperationInProgress(EventImagesState state)
      : super.state(state.copyWith(status: EventImagesStatus.loading));
}

class EventImagesOperationSuccess extends EventImagesState {
  final bool shouldRefresh;
  final String? successMessage;

  EventImagesOperationSuccess(EventImagesState state, {this.shouldRefresh = false, this.successMessage})
      : super.state(state.copyWith(status: EventImagesStatus.success));
}

class EventImagesOperationFailure extends EventImagesState {
  final String errorMessage;

  EventImagesOperationFailure(EventImagesState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventImagesStatus.error));
}