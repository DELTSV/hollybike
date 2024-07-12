import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/user_journey/bloc/user_journey_list_event.dart';
import 'package:hollybike/user_journey/bloc/user_journey_list_state.dart';
import 'package:hollybike/user_journey/services/user_journey_repository.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';

import '../../shared/types/paginated_list.dart';

class UserJourneyListBloc
    extends Bloc<UserJourneyListEvent, UserJourneyListState> {
  final int numberOfUserJourneysPerRequest = 20;

  final UserJourneyRepository userJourneyRepository;
  final int userId;

  UserJourneyListBloc({
    required this.userJourneyRepository,
    required this.userId,
  }) : super(UserJourneyListInitial()) {
    on<LoadUserJourneysNextPage>(_onLoadUserJourneysNextPage);
    on<RefreshUserJourneysImages>(_onRefreshUserJourneys);
  }

  Future<void> _onLoadUserJourneysNextPage(
    LoadUserJourneysNextPage event,
    Emitter<UserJourneyListState> emit,
  ) async {
    if (state.hasMore == false ||
        state.status == UserJourneyListStatus.loading) {
      return;
    }

    emit(UserJourneyListPageLoadInProgress(state));

    try {
      PaginatedList<UserJourney> page =
          await userJourneyRepository.fetchUserJourneys(
        userId,
        state.nextPage,
        numberOfUserJourneysPerRequest,
      );

      emit(UserJourneyListPageLoadSuccess(state.copyWith(
        userJourneys: [...state.userJourneys, ...page.items],
        hasMore: page.items.length == numberOfUserJourneysPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of user journeys', error: e);
      emit(UserJourneyListPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRefreshUserJourneys(
    RefreshUserJourneysImages event,
    Emitter<UserJourneyListState> emit,
  ) async {
    emit(UserJourneyListPageLoadInProgress(state));

    try {
      PaginatedList<UserJourney> page =
          await userJourneyRepository.refreshUserJourneys(
        userId,
        numberOfUserJourneysPerRequest,
      );

      emit(UserJourneyListPageLoadSuccess(state.copyWith(
        userJourneys: page.items,
        hasMore: page.items.length == numberOfUserJourneysPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing user journeys', error: e);
      emit(UserJourneyListPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}

extension FirstWhenNotLoading on UserJourneyListBloc {
  Future<UserJourneyListState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! UserJourneyListPageLoadInProgress;
    });
  }
}
