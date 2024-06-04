import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/services/event_participations/event_participation_repository.dart';
import 'package:hollybike/event/types/event_participation.dart';

import '../../../shared/types/paginated_list.dart';
import 'event_participations_event.dart';
import 'event_participations_state.dart';

class EventParticipationBloc
    extends Bloc<EventParticipationsEvent, EventParticipationsState> {
  final EventParticipationRepository eventParticipationsRepository;
  final int numberOfParticipationsPerRequest = 10;

  EventParticipationBloc({required this.eventParticipationsRepository})
      : super(EventParticipationsInitial()) {
    on<SubscribeToEventParticipations>(_onSubscribeToEventParticipations);
    on<LoadEventParticipationsNextPage>(_onLoadEventParticipationsNextPage);
    on<RefreshEventParticipations>(_onRefreshEvents);
  }

  @override
  Future<void> close() async {
    await eventParticipationsRepository.close();
    return super.close();
  }

  Future<void> _onSubscribeToEventParticipations(
    SubscribeToEventParticipations event,
    Emitter<EventParticipationsState> emit,
  ) async {
    await emit.forEach<List<EventParticipation>>(
      eventParticipationsRepository.participationsStream,
      onData: (participants) => state.copyWith(
        participants: participants,
      ),
    );
  }

  Future<void> _onLoadEventParticipationsNextPage(
    LoadEventParticipationsNextPage event,
    Emitter<EventParticipationsState> emit,
  ) async {
    if (state.hasMore == false ||
        state.status == EventParticipationsStatus.loading) {
      return;
    }

    emit(EventParticipationsPageLoadInProgress(state));

    try {
      PaginatedList<EventParticipation> page =
          await eventParticipationsRepository.fetchParticipations(
        event.eventId,
        event.session,
        state.nextPage,
        numberOfParticipationsPerRequest,
      );

      emit(EventParticipationsPageLoadSuccess(state.copyWith(
        hasMore: page.items.length == numberOfParticipationsPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of events', error: e);
      emit(EventParticipationsPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRefreshEvents(
    RefreshEventParticipations event,
    Emitter<EventParticipationsState> emit,
  ) async {
    emit(EventParticipationsPageLoadInProgress(
        EventParticipationsInitial().copyWith(
      participants: event.participationPreview,
    )));

    try {
      PaginatedList<EventParticipation> page =
          await eventParticipationsRepository.refreshParticipations(
        event.eventId,
        event.session,
        numberOfParticipationsPerRequest,
      );

      emit(EventParticipationsPageLoadSuccess(state.copyWith(
        hasMore: page.items.length == numberOfParticipationsPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing events', error: e);
      emit(EventParticipationsPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}
