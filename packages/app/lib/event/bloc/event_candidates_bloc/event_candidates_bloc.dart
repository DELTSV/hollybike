import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../../../shared/types/paginated_list.dart';
import '../../services/event/event_repository.dart';
import '../../services/participation/event_participation_repository.dart';
import '../../types/participation/event_candidate.dart';
import 'event_candidates_event.dart';
import 'event_candidates_state.dart';

class EventCandidatesBloc
    extends Bloc<EventCandidatesEvent, EventCandidatesState> {
  final int eventId;

  final EventParticipationRepository eventParticipationsRepository;
  final EventRepository eventRepository;
  final int numberOfCandidatesPerRequest = 15;

  EventCandidatesBloc({
    required this.eventId,
    required this.eventParticipationsRepository,
    required this.eventRepository,
  }) : super(EventCandidatesInitial()) {
    on<SubscribeToEventCandidates>(_onSubscribeToEventCandidates);
    on<LoadEventCandidatesNextPage>(_onLoadEventCandidatesNextPage);
    on<RefreshEventCandidates>(_onRefreshEvents);
    on<SearchCandidates>(_onSearchCandidates);
    on<AddCandidates>(_onAddCandidates);
  }

  @override
  Future<void> close() async {
    await eventParticipationsRepository.closeCandidates(eventId);
    return super.close();
  }

  Future<void> _onSubscribeToEventCandidates(
    SubscribeToEventCandidates event,
    Emitter<EventCandidatesState> emit,
  ) async {
    await emit.forEach<List<EventCandidate>>(
      eventParticipationsRepository.candidatesStream(eventId),
      onData: (candidates) => state.copyWith(
        candidates: candidates,
      ),
    );
  }

  Future<void> _onLoadEventCandidatesNextPage(
    LoadEventCandidatesNextPage event,
    Emitter<EventCandidatesState> emit,
  ) async {
    if (state.hasMore == false ||
        state.status == EventCandidatesStatus.loading) {
      return;
    }

    emit(EventCandidatesPageLoadInProgress(state));

    try {
      PaginatedList<EventCandidate> page =
          await eventParticipationsRepository.fetchCandidates(
        event.eventId,
        state.nextPage,
        numberOfCandidatesPerRequest,
        state.search,
      );

      emit(EventCandidatesPageLoadSuccess(state.copyWith(
        hasMore: page.items.length == numberOfCandidatesPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of events', error: e);
      emit(EventCandidatesPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRefreshEvents(
    RefreshEventCandidates event,
    Emitter<EventCandidatesState> emit,
  ) async {
    emit(EventCandidatesPageLoadInProgress(state));

    try {
      PaginatedList<EventCandidate> page =
          await eventParticipationsRepository.refreshCandidates(
        event.eventId,
        numberOfCandidatesPerRequest,
        "",
      );

      emit(EventCandidatesPageLoadSuccess(state.copyWith(
        hasMore: page.items.length == numberOfCandidatesPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing events', error: e);
      emit(EventCandidatesPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onSearchCandidates(
    SearchCandidates event,
    Emitter<EventCandidatesState> emit,
  ) async {
    emit(EventCandidatesPageLoadInProgress(state.copyWith(
      search: event.search,
    )));

    try {
      PaginatedList<EventCandidate> page =
          await eventParticipationsRepository.refreshCandidates(
        event.eventId,
        numberOfCandidatesPerRequest,
        event.search,
      );

      emit(EventCandidatesPageLoadSuccess(state.copyWith(
        hasMore: page.items.length == numberOfCandidatesPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while searching candidates', error: e);
      emit(EventCandidatesPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onAddCandidates(
    AddCandidates event,
    Emitter<EventCandidatesState> emit,
  ) async {
    emit(EventAddCandidatesInProgress(state));

    try {
      final addedParticipants =
          await eventParticipationsRepository.addParticipants(
        event.eventId,
        event.userIds,
        numberOfCandidatesPerRequest,
      );

      eventRepository.onParticipantsAdded(addedParticipants, event.eventId);

      emit(EventAddCandidatesSuccess(state));
    } catch (e) {
      log('Error while adding candidates', error: e);
      emit(EventAddCandidatesFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}
