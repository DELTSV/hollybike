import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/profile/bloc/profile_repository.dart';
import 'package:hollybike/search/bloc/search_event.dart';

import '../../event/types/minimal_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final EventRepository eventRepository;
  final ProfileRepository profileRepository;
  final int numberOfEventsPerRequest = 10;

  SearchBloc({
    required this.eventRepository,
    required this.profileRepository,
  }) : super(SearchInitial()) {
    on<SubscribeToEventsSearch>(_onSubscribeToEventsSearch);
    on<LoadEventsSearchNextPage>(_onLoadEventsSearchNextPage);
    on<LoadProfilesSearchNextPage>(_onLoadProfilesSearchNextPage);
    on<RefreshSearch>(_onRefreshSearch);
  }

  @override
  Future<void> close() async {
    await eventRepository.close();
    return super.close();
  }

  Future<void> _onSubscribeToEventsSearch(
    SubscribeToEventsSearch event,
    Emitter<SearchState> emit,
  ) async {
    await emit.forEach<List<MinimalEvent>>(
      eventRepository.searchEventsStream,
      onData: (events) => state.copyWith(events: events),
    );
  }

  Future<void> _onLoadEventsSearchNextPage(
    LoadEventsSearchNextPage event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasMoreEvents == false || state.status == SearchStatus.loading) {
      return;
    }

    emit(SearchLoadInProgress(state));

    try {
      final page = await eventRepository.fetchEvents(
        event.session,
        null,
        state.eventsNextPage,
        numberOfEventsPerRequest,
        query: event.query,
      );

      emit(
        SearchLoadSuccess(
          state.copyWith(
            hasMoreEvents: page.items.length == numberOfEventsPerRequest,
            eventsNextPage: state.eventsNextPage + 1,
          ),
        ),
      );
    } catch (e) {
      emit(handleError(e, 'Error while loading next page of events'));
    }
  }

  Future<void> _onLoadProfilesSearchNextPage(
      LoadProfilesSearchNextPage event,
      Emitter<SearchState> emit,
      ) async {
    if (state.hasMoreEvents == false || state.status == SearchStatus.loading) {
      return;
    }

    emit(SearchLoadInProgress(state));

    try {
      final page = await profileRepository.searchProfiles(
        event.session,
        state.profilesNextPage,
        state.eventsNextPage,
        event.query,
      );

      emit(
        SearchLoadSuccess(
          state.copyWith(
            hasMoreProfiles: page.items.length == numberOfEventsPerRequest,
            eventsNextPage: state.profilesNextPage + 1,
          ),
        ),
      );
    } catch (e) {
      emit(handleError(e, 'Error while loading next page of profiles'));
    }
  }

  Future<void> _onRefreshSearch(
    RefreshSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoadInProgress(const SearchState()));

    try {
      final eventsPage = await eventRepository.refreshEvents(
        event.session,
        null,
        numberOfEventsPerRequest,
        query: event.query,
      );

      final profilesPage = await profileRepository.searchProfiles(
        event.session,
        null,
        numberOfEventsPerRequest,
        event.query,
      );

      emit(
        SearchLoadSuccess(
          state.copyWith(
            hasMoreEvents: eventsPage.items.length == numberOfEventsPerRequest,
            eventsNextPage: 1,
            profiles: profilesPage.items,
            hasMoreProfiles: profilesPage.items.length == numberOfEventsPerRequest,
            profilesNextPage: 1,
          ),
        ),
      );
    } catch (e) {
      emit(handleError(e, 'Error while refreshing search'));
    }
  }

  SearchState handleError(Object e, String logMessage) {
    log(logMessage, error: e);
    return SearchLoadFailure(
      state,
      errorMessage: 'Une erreur est survenue.',
    );
  }
}
