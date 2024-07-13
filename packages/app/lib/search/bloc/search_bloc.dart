import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/search/bloc/search_event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

import '../../event/types/minimal_event.dart';
import '../../profile/services/profile_repository.dart';
import '../../shared/utils/streams/stream_value.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final EventRepository eventRepository;
  final ProfileRepository profileRepository;

  SearchBloc({
    required this.eventRepository,
    required this.profileRepository,
  }) : super(SearchInitial()) {
    on<SubscribeToEventsSearch>(_onSubscribeToEventsSearch);
    on<LoadEventsSearchNextPage>(_onLoadEventsSearchNextPage);
    on<LoadProfilesSearchNextPage>(_onLoadProfilesSearchNextPage);
    on<RefreshSearch>(_onRefreshSearch);
  }

  Future<void> _onSubscribeToEventsSearch(
    SubscribeToEventsSearch event,
    Emitter<SearchState> emit,
  ) async {
    await emit.forEach<StreamValue<List<MinimalEvent>, RefreshedType>>(
      eventRepository.searchEventsStream,
      onData: (data) {
        final events = data.value;
        final isRefreshed = data.state;

        if (isRefreshed == RefreshedType.none) {
          return state.copyWith(
            events: events,
          );
        }

        return SearchLoadSuccess(
          state.copyWith(
            events: events,
            hasMoreEvents: isRefreshed == RefreshedType.refreshedAndHasMore,
            eventsNextPage: 1,
          ),
        );
      },
    );
  }

  Future<void> _onLoadEventsSearchNextPage(
    LoadEventsSearchNextPage event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasMoreEvents == false ||
        state.status == SearchStatus.loadingEvents ||
        state.lastSearchQuery == null) {
      return;
    }

    emit(SearchLoadInProgress(state, SearchStatus.loadingEvents));

    try {
      final page = await eventRepository.fetchEvents(
        null,
        state.eventsNextPage,
        query: state.lastSearchQuery as String,
      );

      emit(
        SearchLoadSuccess(
          state.copyWith(
            hasMoreEvents:
                page.items.length == eventRepository.numberOfEventsPerRequest,
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
    if (state.hasMoreProfiles == false ||
        state.status == SearchStatus.loadingProfiles ||
        state.lastSearchQuery == null) {
      return;
    }

    emit(SearchLoadInProgress(state, SearchStatus.loadingProfiles));

    try {
      final page = await profileRepository.searchProfiles(
        state.profilesNextPage,
        state.eventsNextPage,
        state.lastSearchQuery as String,
      );

      emit(
        SearchLoadSuccess(
          state.copyWith(
            profiles: state.profiles + page.items,
            hasMoreProfiles:
                page.items.length == eventRepository.numberOfEventsPerRequest,
            profilesNextPage: state.profilesNextPage + 1,
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
    emit(SearchLoadInProgress(const SearchState(), SearchStatus.fullLoading));

    try {
      await eventRepository.refreshEvents(
        null,
        query: event.query,
      );

      final profilesPage = await profileRepository.searchProfiles(
        null,
        eventRepository.numberOfEventsPerRequest,
        event.query,
      );

      emit(
        SearchLoadSuccess(
          state.copyWith(
            lastSearchQuery: event.query,
            profiles: profilesPage.items,
            hasMoreProfiles: profilesPage.items.length ==
                eventRepository.numberOfEventsPerRequest,
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
