import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_event.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_state.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/user_journey/services/user_journey_repository.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';

class ProfileJourneysBloc
    extends Bloc<ProfileJourneysEvent, ProfileJourneysState> {
  final int numberOfUserJourneysPerRequest = 10;

  final UserJourneyRepository userJourneyRepository;
  final int userId;

  ProfileJourneysBloc({
    required this.userJourneyRepository,
    required this.userId,
  }) : super(ProfileJourneysInitial()) {
    on<LoadProfileJourneysNextPage>(_onLoadUserJourneysNextPage);
    on<RefreshProfileJourneys>(_onRefreshUserJourneys);
  }

  Future<void> _onLoadUserJourneysNextPage(
    LoadProfileJourneysNextPage event,
    Emitter<ProfileJourneysState> emit,
  ) async {
    if (state.hasMore == false ||
        state.status == ProfileJourneysStatus.loading) {
      return;
    }

    emit(ProfileJourneysPageLoadInProgress(state));

    try {
      PaginatedList<UserJourney> page =
          await userJourneyRepository.fetchUserJourneys(
        state.nextPage,
        numberOfUserJourneysPerRequest,
        userId,
      );

      emit(ProfileJourneysPageLoadSuccess(state.copyWith(
        userJourneys: [...state.userJourneys, ...page.items],
        hasMore: page.items.length == numberOfUserJourneysPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of user journeys', error: e);
      emit(ProfileJourneysPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRefreshUserJourneys(
    RefreshProfileJourneys event,
    Emitter<ProfileJourneysState> emit,
  ) async {
    emit(ProfileJourneysPageLoadInProgress(state));

    try {
      PaginatedList<UserJourney> page =
          await userJourneyRepository.refreshUserJourneys(
        numberOfUserJourneysPerRequest,
        userId,
      );

      emit(ProfileJourneysPageLoadSuccess(state.copyWith(
        userJourneys: page.items,
        hasMore: page.items.length == numberOfUserJourneysPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing user journeys', error: e);
      emit(ProfileJourneysPageLoadFailure(
        state.copyWith(
          userJourneys: [],
          hasMore: false,
        ),
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}

extension FirstWhenNotLoading on ProfileJourneysBloc {
  Future<ProfileJourneysState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! ProfileJourneysPageLoadInProgress;
    });
  }
}
