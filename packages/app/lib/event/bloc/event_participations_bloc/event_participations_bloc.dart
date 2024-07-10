import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/shared/utils/streams/stream_value.dart';

import '../../../shared/types/paginated_list.dart';
import '../../services/participation/event_participation_repository.dart';
import '../../types/participation/event_participation.dart';
import 'event_participations_event.dart';
import 'event_participations_state.dart';

class EventParticipationBloc
    extends Bloc<EventParticipationsEvent, EventParticipationsState> {
  final int eventId;

  final EventParticipationRepository eventParticipationsRepository;
  final EventRepository eventRepository;
  final int numberOfParticipationsPerRequest = 15;

  EventParticipationBloc({
    required this.eventId,
    required this.eventParticipationsRepository,
    required this.eventRepository,
  }) : super(EventParticipationsInitial()) {
    on<SubscribeToEventParticipations>(_onSubscribeToEventParticipations);
    on<LoadEventParticipationsNextPage>(_onLoadEventParticipationsNextPage);
    on<RefreshEventParticipations>(_onRefreshParticipations);
    on<PromoteEventParticipant>(_onPromoteEventParticipant);
    on<DemoteEventParticipant>(_onDemoteEventParticipant);
    on<RemoveEventParticipant>(_onRemoveEventParticipant);
  }

  Future<void> _onSubscribeToEventParticipations(
    SubscribeToEventParticipations event,
    Emitter<EventParticipationsState> emit,
  ) async {
    await emit.forEach<StreamValue<List<EventParticipation>, void>>(
      eventParticipationsRepository.participationsStream(eventId),
      onData: (data) => state.copyWith(
        participants: data.value,
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
        eventId,
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

  Future<void> _onRefreshParticipations(
    RefreshEventParticipations event,
    Emitter<EventParticipationsState> emit,
  ) async {
    final participants = state.participants.isEmpty
        ? event.participationPreview
        : state.participants;

    emit(EventParticipationsPageLoadInProgress(
        EventParticipationsInitial().copyWith(
      participants: participants,
    )));

    try {
      PaginatedList<EventParticipation> page =
          await eventParticipationsRepository.refreshParticipations(
        eventId,
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

  Future<void> _onPromoteEventParticipant(
    PromoteEventParticipant event,
    Emitter<EventParticipationsState> emit,
  ) async {
    emit(EventParticipationsOperationInProgress(state));

    try {
      await eventParticipationsRepository.promoteParticipant(
        eventId,
        event.userId,
      );

      emit(EventParticipationsOperationSuccess(state,
          successMessage: 'Participant promu.'));
    } catch (e) {
      log('Error while promoting participant', error: e);
      emit(EventParticipationsOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onDemoteEventParticipant(
    DemoteEventParticipant event,
    Emitter<EventParticipationsState> emit,
  ) async {
    emit(EventParticipationsOperationInProgress(state));

    try {
      await eventParticipationsRepository.demoteParticipant(
        eventId,
        event.userId,
      );

      emit(EventParticipationsOperationSuccess(state,
          successMessage: 'Participant rétrogradé.'));
    } catch (e) {
      log('Error while demoting participant', error: e);
      emit(EventParticipationsOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRemoveEventParticipant(
    RemoveEventParticipant event,
    Emitter<EventParticipationsState> emit,
  ) async {
    emit(EventParticipationsDeletionInProgress(state));

    try {
      await eventParticipationsRepository.removeParticipant(
        eventId,
        event.userId,
      );

      eventRepository.onParticipantRemoved(event.userId, eventId);

      emit(EventParticipationsDeleted(state));
    } catch (e) {
      log('Error while removing participant', error: e);
      emit(EventParticipationsDeletionFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}

extension FirstWhenNotLoading on EventParticipationBloc {
  Future<EventParticipationsState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! EventParticipationsPageLoadInProgress;
    });
  }
}
