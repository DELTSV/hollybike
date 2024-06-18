import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';

enum SearchStatus { loading, success, error, initial }

@immutable
class SearchState<D> {
  final List<D> data;

  final SearchStatus status;

  final bool hasMore;
  final int nextPage;

  const SearchState({
    this.data = const [],
    this.hasMore = true,
    this.nextPage = 0,
    this.status = SearchStatus.initial,
  });

  SearchState<D> copyWith({
    List<D>? data,
    bool? hasMore,
    int? nextPage,
    Event? createdEvent,
  }) {
    return SearchState(
      data: data ?? this.data,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class SearchInitial<D> extends SearchState<D> {}

class SearchLoadInProgress<D> extends SearchState<D> {
  SearchLoadInProgress(SearchState<D> state)
      : super(
          data: state.data,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: SearchStatus.loading,
        );
}

class SearchLoadSuccess<D> extends SearchState<D> {
  SearchLoadSuccess(SearchState<D> state)
      : super(
          data: state.data,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: SearchStatus.success,
        );
}

class SearchLoadFailure<D> extends SearchState<D> {
  final String errorMessage;

  SearchLoadFailure(SearchState<D> state, {required this.errorMessage})
      : super(
          data: state.data,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: SearchStatus.error,
        );
}
