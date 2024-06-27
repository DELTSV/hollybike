import 'package:flutter/foundation.dart';
import 'package:hollybike/event/types/image/event_image_details.dart';

enum EventImageDetailsStatus { loading, success, error, initial }

@immutable
class EventImageDetailsState {
  final EventImageDetails? imageDetails;
  final EventImageDetailsStatus status;

  const EventImageDetailsState({
    this.imageDetails,
    this.status = EventImageDetailsStatus.initial,
  });

  EventImageDetailsState.state(EventImageDetailsState state)
      : this(
          imageDetails: state.imageDetails,
          status: state.status,
        );

  EventImageDetailsState copyWith({
    EventImageDetailsStatus? status,
    EventImageDetails? imageDetails,
  }) {
    return EventImageDetailsState(
      imageDetails: imageDetails ?? this.imageDetails,
      status: status ?? this.status,
    );
  }
}

class EventImageDetailsInitial extends EventImageDetailsState {}

class EventImageDetailsLoadInProgress extends EventImageDetailsState {
  EventImageDetailsLoadInProgress(EventImageDetailsState state)
      : super.state(state.copyWith(status: EventImageDetailsStatus.loading));
}

class EventImageDetailsLoadSuccess extends EventImageDetailsState {
  EventImageDetailsLoadSuccess(EventImageDetailsState state)
      : super.state(state.copyWith(status: EventImageDetailsStatus.success));
}

class EventImageDetailsLoadFailure extends EventImageDetailsState {
  final String errorMessage;

  EventImageDetailsLoadFailure(EventImageDetailsState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventImageDetailsStatus.error));
}

class DeleteImageInProgress extends EventImageDetailsState {
  DeleteImageInProgress(EventImageDetailsState state)
      : super.state(state.copyWith(status: EventImageDetailsStatus.loading));
}

class DeleteImageSuccess extends EventImageDetailsState {
  DeleteImageSuccess(EventImageDetailsState state)
      : super.state(state.copyWith(status: EventImageDetailsStatus.success));
}

class DeleteImageFailure extends EventImageDetailsState {
  final String errorMessage;

  DeleteImageFailure(EventImageDetailsState state, {required this.errorMessage})
      : super.state(state.copyWith(status: EventImageDetailsStatus.error));
}
