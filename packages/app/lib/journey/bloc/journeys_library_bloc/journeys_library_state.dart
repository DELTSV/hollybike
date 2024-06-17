import 'package:flutter/foundation.dart';
import 'package:hollybike/journey/type/journey.dart';


enum JourneysLibraryStatus { loading, success, error, initial }


@immutable
class JourneysLibraryState {
  final List<Journey> journeys;

  final bool hasMore;
  final int nextPage;

  final JourneysLibraryStatus status;

  const JourneysLibraryState({
    this.journeys = const [],
    this.hasMore = true,
    this.nextPage = 0,
    this.status = JourneysLibraryStatus.initial,
  });

  JourneysLibraryState.state(JourneysLibraryState state)
      : this(
    journeys: state.journeys,
    hasMore: state.hasMore,
    nextPage: state.nextPage,
    status: state.status,
  );

  JourneysLibraryState copyWith({
    JourneysLibraryStatus? status,
    List<Journey>? journeys,
    bool? hasMore,
    int? nextPage,
  }) {
    return JourneysLibraryState(
      status: status ?? this.status,
      journeys: journeys ?? this.journeys,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class JourneysLibraryInitial extends JourneysLibraryState {}

class JourneysLibraryPageLoadInProgress extends JourneysLibraryState {
  JourneysLibraryPageLoadInProgress(JourneysLibraryState state)
      : super.state(state.copyWith(status: JourneysLibraryStatus.loading));
}

class JourneysLibraryPageLoadSuccess extends JourneysLibraryState {
  JourneysLibraryPageLoadSuccess(JourneysLibraryState state)
      : super.state(state.copyWith(status: JourneysLibraryStatus.success));
}

class JourneysLibraryPageLoadFailure extends JourneysLibraryState {
  final String errorMessage;

  JourneysLibraryPageLoadFailure(JourneysLibraryState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: JourneysLibraryStatus.error));
}