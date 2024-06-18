import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/search/bloc/search_event.dart';
import 'package:hollybike/search/services/search_repository.dart';
import 'package:hollybike/shared/types/dto_compatible.dart';

import 'search_state.dart';

abstract class SearchBloc<D, F extends DtoCompatibleFactory<D>>
    extends Bloc<SearchEvent, SearchState<D>> {
  final SearchRepository<D, F> searchRepository;
  final int numberOfEventsPerRequest = 10;

  SearchBloc({required this.searchRepository}) : super(SearchInitial<D>()) {
    on<LoadSearchNextPage>(onLoadSearchNextPage);
    on<RefreshSearch>(_onRefreshSearch);
  }

  Future<void> onLoadSearchNextPage(
    LoadSearchNextPage event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasMore == false || state.status == SearchStatus.loading) {
      return;
    }

    emit(SearchLoadInProgress<D>(state));

    try {
      final page = await searchRepository.fetchSearch(
        event.session,
        state.nextPage,
        numberOfEventsPerRequest,
      );

      emit(
        SearchLoadSuccess<D>(
          state.copyWith(
            hasMore: page.items.length == numberOfEventsPerRequest,
            nextPage: state.nextPage + 1,
          ),
        ),
      );
    } catch (e) {
      emit(handleError(e, 'Error while loading next page of events'));
    }
  }

  Future<void> _onRefreshSearch(
    RefreshSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoadInProgress<D>(const SearchState()));

    try {
      final page = await searchRepository.refreshSearch(
        event.session,
        numberOfEventsPerRequest,
      );

      emit(
        SearchLoadSuccess<D>(
          state.copyWith(
            hasMore: page.items.length == numberOfEventsPerRequest,
            nextPage: 1,
          ),
        ),
      );
    } catch (e) {
      emit(handleError(e, 'Error while refreshing events'));
    }
  }

  SearchState handleError(Object e, String logMessage) {
    log(logMessage, error: e);
    return SearchLoadFailure<D>(
      state,
      errorMessage: 'Une erreur est survenue.',
    );
  }
}
